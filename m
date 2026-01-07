Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A31D0D16D
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282386B0092; Wed,  7 Jan 2026 15:14:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B026B0093; Wed,  7 Jan 2026 15:14:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166806B0095; Wed,  7 Jan 2026 15:14:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 064266B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:14:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93EDD1B101
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:14:21 +0000 (UTC)
X-FDA: 84306269922.12.9955C15
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id B4648180005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:14:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CzbPETCG;
	spf=pass (imf06.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767816859; a=rsa-sha256;
	cv=none;
	b=gOikCj6txXi2Jb0jcFrWreB/nH+jJ+Iiuq1Cy9PrfIl9szHhQx4/QkH19gjT3R7GpFxTWQ
	TvuNoUOxadtnIipsNl3v8I6wZoByRnlZie2XJhlliWngK5gv7TpkXvGuXmcRz2m8Y/hp/j
	N695AzOvwizwV/Io4rn+9W+t610KMng=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CzbPETCG;
	spf=pass (imf06.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767816859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/aAUU7oRurHReAnd439MKGK9jt+5i42ycUj2/5vO6Ag=;
	b=J+I3eM0I/VL5d4GuOVDbmGLgsYFZWwPSIUWm8v1UQsOLe2p56IPI2uy19xSiwJUrO740iv
	H4a19AMppZq5zQyU9L9ol+lHoUdV0ecF5+pQHkHYJqNjby0vqVxQo0co7BEn4BnYnncpoy
	0juhIMlYSe8KD98AltNhJXHr4vuT3R8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767816858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/aAUU7oRurHReAnd439MKGK9jt+5i42ycUj2/5vO6Ag=;
	b=CzbPETCG9fj0MlRIN9bXsMBn/mIv8NCJif1IeW9JT0K/e9xyj5eC2XQRYH4mAKI+kLdLr3
	6I9JAYc2hgnmmbMJGxAfN2zVe++HK9s1u66DGb9BOAomf9GK7UeNKbZt/kNfYxbDTUv/nn
	lhsOhBIVBG/3FWIHVJPqno6klQVRbGQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-DjI8NVljOIqS7WoYWekLlA-1; Wed,
 07 Jan 2026 15:14:16 -0500
X-MC-Unique: DjI8NVljOIqS7WoYWekLlA-1
X-Mimecast-MFC-AGG-ID: DjI8NVljOIqS7WoYWekLlA_1767816855
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02A8B18005B2;
	Wed,  7 Jan 2026 20:14:15 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B162C1956048;
	Wed,  7 Jan 2026 20:14:11 +0000 (UTC)
Date: Wed, 7 Jan 2026 21:14:09 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Pedro Falcato <pfalcato@suse.de>
cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    Alex Deucher <alexander.deucher@amd.com>, 
    =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org, 
    linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
    Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
In-Reply-To: <mfgqbtiqtl7cxzxhvu6ossi5umek2vpb2rag2bcqsof7ommvfz@uz6fqkc2jhik>
Message-ID: <2a209a2a-12dd-96ec-9f3b-46c9b19a468a@redhat.com>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com> <7whbqlfrwjr4z2d4bpny3rjyl5tetdyx7ccf52uvby7hgywoym@6l6m2xcytez7> <e60858c9-12a6-2b04-35ae-9d676f14db2a@redhat.com> <j3dy3g5mchtdzxldtnqu5nwaalbr6ec4ceim3nuu6nwcddmqjc@7dgzr4m7pli2>
 <6633f8ed-f432-f4c4-3fe2-8c14248cadab@redhat.com> <mfgqbtiqtl7cxzxhvu6ossi5umek2vpb2rag2bcqsof7ommvfz@uz6fqkc2jhik>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a1HtVIh2GvIv1bCnP9Or26En_aI7O6llZPXgAKSXPUA_1767816855
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: B4648180005
X-Rspam-User: 
X-Stat-Signature: x5segtf96xmpxn5j893w6as7dks787qi
X-Rspamd-Server: rspam07
X-HE-Tag: 1767816858-159329
X-HE-Meta: U2FsdGVkX1+bFqOX1tcrN44dA0Z+26b/en6CPQEXV8g41g+P6UpgdSsgYZzFQLxmEi6g5U0VEtJNARiv5CIOJWrQ3cYwOWOd1sLt/2WzrBhprYZ4UQRDRd6SmQ/tdH5UDWJAH6vy71R+4jbiHthVg3aIEmq/fdkCUqqNGZ4DBlGZ475Vfj4AR3JIpFSvUdkWjVuf8RlgF0HOrpfjQPov6SVsHAMWtRlU6neVPr3p2qwBjSSiyKHkKLUYxAWVliLiriPHIAv62foihtK39LJ2Ny+2NH5Ir65V37P2ybzCKQpUK3y76S/dSYTPvdhTKqxuaap2mmavcyQLYB27cF8idY80rR6qc96IoydI4vdZY/THGBe9af/OXbA+Y6Cw8K8zdm/Uxj5g2lqvTKKXqGTjStrvywhdC9+iUoNt8xiEnqsDGSyC44zdp4re1P3iVaIICG84n4WYtFMPLOpz2df89NavBrPnDCie+a2V1YarHCDJE3q7wfB8mBXD9B5blIURRjfQb28KFwcZxddNIzBHp8LmDyUf+q2TFyhn4rmAzw9FBVhl1szbXA10DoF0+XRz3VZXruFHDud9nAcFPRDtfvZ4kMgZalOecghia5A9R0QSzl+8KTDpw38QgZS08APdcdXt98EDs75XCm930T8Av97NPeu9Lm5Hq87Lca7OfrGDi7hxLC1vJcRYPtXeBFYRf0APpT6Tor7jA4iKcX9m5n3UEYUkhEacjL3LNVbB6EdqroUL+jyF4CxuP/1uFw26+thGijhH2IWfJfpmha5Yi/InDHKiMYKEgAKeaMMCfRFp0tUyu6DTZdv5HoxQeJG0pziub5heABDenL5Id4BdGpWhFIEcx7+MgvAD0Pj1J8eEOtAE4qV0cStFpXTeQ+Bk3x78FqASFzzmtEaVbj19f/xEAp0AepZj983ENm7Cv8Ecz2+6TcM+C8N3GFC5ZN1z+TjfRZ9hcese/fJX1J2
 IyfDSf3t
 qtqV970Jzh/3o9VNwLzrBFKeA09M5wao5dyfi4Y5GxBo0EZO41jmo0iW25Lfc/zLfhApFq0mcQC95JswbKcIlLnjY+UdoIaoll2oPoXAs207V/v9404yD181a+VBdyI0ylrO0KQxOqX9eZyFDTei9Tz46h2Tq2eit8YexAmbJc/Y6ZLISJ/iqtORNeHIy73mPslW5WSf79i+OK/f1fFga3A1q6miOVjCn+NhvpfAmvIQvrLYJ9zOM46OZXPRhApwOhLkzdn9u5yoIMt1XOCAlGLi3AEr/JDNa30BKFyi8nvNXp3LLXqSlM1l3tLdKBeKJ8mhnLspAjuVGv62aX82z1MRXINa2Xwlht+/fEkPiMt44E2A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Tue, 6 Jan 2026, Pedro Falcato wrote:

> On Tue, Jan 06, 2026 at 09:19:59PM +0100, Mikulas Patocka wrote:
> > 
> > 
> > On Tue, 6 Jan 2026, Liam R. Howlett wrote:
> > 
> > > Okay, so the other call paths also end up getting the -EINTR from this
> > > function?  Can you please add that detail to the commit message?
> > 
> > Yes. I'd like to ask the GPU people to look at it and say how much damage 
> > this -EINTR could do. I don't know - I just saw the messages "Failed to 
> > register MMU notifier: -4" in the syslog.

I read the ROCm source code and it seems to restart all ioctls on EINTR or 
EAGAIN correctly.

So, this syslog message is harmless.

The only problem is that open() is not restarted (even if the signal has 
the SA_RESTART flag).

> > > Any other -EINTR system call will also cause you problems since you
> > > continuously send signals to your process, so we'll have to change them
> > > all for this to work?
> > 
> > I use SA_RESTART for the signals. And I retry all the syscalls on EINTR 
> > just in case SA_RESTART didn't work. So, I don't experience random 
> > failures in my code due to the periodic signal.
> > 
> > But there is code that I have no control over - such as the OpenCL shared 
> > library.
> 
> Right. So I am wondering if just returning -ERESTARTSYS (whether in
> mm_take_all_locks(), or in the AMD driver) would satisfy both parties.
> 
> Folks installing and using signals need to pay attention and set
> SA_RESTART, but that's already best practice when dealing with third-party
> code. open(2) should be transparently restartable.
> 
> WDYT?

I tested it with -ERESTARTSYS and it works. I get the messages 
"init_user_pages: Failed to register MMU notifier: -512" in the syslog - 
but that is benign.

Mikulas


