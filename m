Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFABE9A025
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 17:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5446C6B0088; Tue, 17 Feb 2026 12:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B396B0089; Tue, 17 Feb 2026 12:43:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448366B008A; Tue, 17 Feb 2026 12:43:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3299F6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:43:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CEC031A0286
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:43:50 +0000 (UTC)
X-FDA: 84454671420.04.BC6BB88
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id D810B2000E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:43:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gbx+l4v3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of luyang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luyang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771350229; a=rsa-sha256;
	cv=none;
	b=HKmRK0D88Z4q5iqkFKgfVMMdKFPAmA6zgrNgwCJpwf1RlBN2Bp86X4UXm15WVVnHA3B7Vp
	cQ5DG+QI5eW6J6eBmIP3kGbpgFtIfGvTgXAkY4HO3EC9gEcuELs9IuLA1dOrfzgGJN0usu
	lT8rB9owD/KOzqiXxEPw/SDQFP75MC0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gbx+l4v3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of luyang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luyang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771350229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=poXugDg94mqOoGIdahpQoY5scXHKHEeEHQyw1IJe2XU=;
	b=YdvymGRIdQANeiVVJYhGnJRR/CNYSCUeh7kbGkRJ17zYH3TGZrSBlArhJ0e+n4cH0nFIwN
	+A816pYXwZLeK2oPObqmMvLO/LTR1Mhc7kzo1+5TU1zjFGDtjeUpK6lygM3Rog2piurIyz
	tuQZ9fXV0MEcIOV49WGwUGJXMyn5xpU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771350227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=poXugDg94mqOoGIdahpQoY5scXHKHEeEHQyw1IJe2XU=;
	b=gbx+l4v3/k067tEheilCMxzpZ4VEktfT+r8y+y3m8oLQ3H612hdWTcUqnuRQjPBLKYXU5v
	3tvMramGbh3OubpyoXmi+VQMMEnR063/+1n73T9NugWCzXGOI3UCCghmD/lwvjLWJRIPZn
	yfcIJYa9W9L7UbURY4iHOZ2VHnvZn2w=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-fNBTH5yiOvG_a6W2VSiR1g-1; Tue,
 17 Feb 2026 12:43:43 -0500
X-MC-Unique: fNBTH5yiOvG_a6W2VSiR1g-1
X-Mimecast-MFC-AGG-ID: fNBTH5yiOvG_a6W2VSiR1g_1771350221
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E02519560B2;
	Tue, 17 Feb 2026 17:43:40 +0000 (UTC)
Received: from localhost (unknown [10.22.89.47])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B598130001A5;
	Tue, 17 Feb 2026 17:43:39 +0000 (UTC)
Date: Tue, 17 Feb 2026 12:43:38 -0500
From: Luke Yang <luyang@redhat.com>
To: Dev Jain <dev.jain@arm.com>
Cc: pfalcato@suse.de, david@kernel.org, surenb@google.com,
	jhladky@redhat.com, akpm@linux-foundation.org,
	Liam.Howlett@oracle.com, willy@infradead.org, vbabka@suse.cz,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions
 since PTE batching (cac1db8c3aad)
Message-ID: <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
 <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
 <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
 <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
 <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
 <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
MIME-Version: 1.0
In-Reply-To: <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: iL5T87aW5TT769B17YJ6B1Hguz-z6Mht-PPF0Mh1vuw_1771350221
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1okw3k1xzdqnowtgpkq4krdeajgp7fe7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D810B2000E
X-HE-Tag: 1771350228-824888
X-HE-Meta: U2FsdGVkX1+7cvQxVld327ceBNJF0ypYcbXMvqAYNUXg0fWUVNteoQFSQyFXGf49NSJy8wxfNUemnoHvk1ZRqRhh6lOlpYamm8IwwMgkocPy/l4KaKPwIj1Bd9PY/wCsDF93HoT8sPV0UpvIDoeHlcaE5WxIb7n4L1YhYBpH4oGI9KtFjjz/N3i6EoCcGyKwi3nyJqY+LAns15kp7Qa+rbilTcg9FTwU5a1AF5+HqlduF0eJSRNMG0BW4N+KuWZ5+x322vI1lQCuWe0wPKxH/F7aC17TH7RvLZ5o1oU05Ggn0BOjFkCEBs2HAfvguDBZUTD4U0Op7LxaKziMvbeVy0JalWE1yk6AB2PJnNGUFQubalMBSpHuIHRt8qfxwCG5s1aZsb2/6DGGXR5lIRPdX3MRyj0eA71C47FbJWGVE/uoyW6hg0Xza5n5GoqdHAUbwT+NG15csyhIKX5z4OYU94IjYUwiBgrOT5dtNdMVj0P0DPvTm3UkdaFr7qvbp9fa9MPJX3tuA5HxnXDaQ4Jd/C8tnO2dTuP/vV2BX6uwwO+rSrZZVZQUi7SGL37LdJ9VRnTf7vIvo0RNpo1wfVLRHzx71eqlNt8QQKjcmUZHKKVrDY9Gssc5dC9htqZRadC5wy6YEcpmNRh5WJcPX5vf8gIS1fJUDgoeYnxmQh4dmHJTJEtweF7/9O9xvJ4hnCd+EDx12m9Un4yXGaIY18LFZeCChpUCrtYsyjCY218oH+vXxh0XnTqkBOs85MUEGl8Ph0gY2oYvqY3AUQ3Ko3uYWhpZg8I5OqeNxoUURNsPlaGllKlDgXNnwqtAX92XUb1e7Wy7tbxKpAqJrPcSKtVyi5HCAJSVDx6XxOLJng/vlm35spDxqEEFj26be8qzTIpIlRIErZstnPxWqVS8F7LJUIN0QvwOWPizuoz2DKoMRuKqh14V8LK2SXaVCjejPSic47lQ8ltkAwkLF6TiXPm
 MC94JTyk
 VqtLY0IBuPnaZa5L+f9aYlteGjXYYz72PuZSEvgiWI4QJ5XcpbtEEMbumWStCrMD6drjNJ7t/dDexDzqq3ljm7z4aCgB9VctGPjXhQhn3L6p8Ws/twDXTahhbnd0mMa784opY82yU0GqRSTLQZ3MGcFB3pKyuUkzAeMjE36mRVcAS4r2X3bJnLJFQTlBtMhYIV0JRd9GulENdRmVO25yiane3zOWhtef9Qx+mKg5MDKOHAgwJvddJjRT9kr6OgGr5irA2/0za/tDlfESoyJPkw/xspl6U1X1SqukBMaod/oBhnFoP4V9Xux4uu2GzotOd20KTKOuLR+WPvOa0Au0g9H6LznAbL0tHRM1URmDMxKWOybf3KHXNJxDBLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 03:42:08PM +0530, Dev Jain wrote:
> 
> On 13/02/26 10:56 pm, David Hildenbrand (Arm) wrote:
> > On 2/13/26 18:16, Suren Baghdasaryan wrote:
> >> On Fri, Feb 13, 2026 at 4:24 PM Pedro Falcato <pfalcato@suse.de> wrote:
> >>>
> >>> On Fri, Feb 13, 2026 at 04:47:29PM +0100, David Hildenbrand (Arm) wrote:
> >>>>
> >>>> Hi!
> >>>>
> >>>>
> >>>> Micro-benchmark results are nice. But what is the real word impact?
> >>>> IOW, why
> >>>> should we care?
> >>>
> >>> Well, mprotect is widely used in thread spawning, code JITting,
> >>> and even process startup. And we don't want to pay for a feature we can't
> >>> even use (on x86).
> >>
> >> I agree. When I straced Android's zygote a while ago, mprotect() came
> >> up #30 in the list of most frequently used syscalls and one of the
> >> most used mm-related syscalls due to its use during process creation.
> >> However, I don't know how often it's used on VMAs of size >=400KiB.
> >
> > See my point? :) If this is apparently so widespread then finding a real
> > reproducer is likely not a problem. Otherwise it's just speculation.
> >
> > It would also be interesting to know whether the reproducer ran with any
> > sort of mTHP enabled or not. 
> 
> Yes. Luke, can you experiment with the following microbenchmark:
> 
> https://pastebin.com/3hNtYirT
> 
> and see if there is an optimization for pte-mapped 2M folios, before and
> after the commit?
> 
> (set transparent_hugepages/enabled=always, hugepages-2048Kb/enabled=always)

----------
amd-epyc2-rome

# before commit
$ uname -r
6.16.0-65.eln150.x86_64
# after commit
$ uname -r
6.17.0-0.rc1.17.eln150.x86_64

$ cat /sys/kernel/mm/transparent_hugepage/enabled
[always] madvise never

$ cat /sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled
[always] inherit madvise never

Before commit: Total = 6895988972
After commit: Total = 2303697782
Percentage change: -66.6%

----------
amd-epyc3-milanx

# before commit
$ uname -r
6.16.0-65.eln150.x86_64
# after commit
$ uname -r
6.17.0-0.rc1.17.eln150.x86_64

$ cat /sys/kernel/mm/transparent_hugepage/enabled
[always] madvise never

$ cat /sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled
[always] inherit madvise never

Before commit: Total = 4006750392
After commit: Total = 1497733191
Percentage change: -62.6%
----------

Luke


