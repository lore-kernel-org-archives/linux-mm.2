Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AE5CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 06:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 623A68E0008; Thu, 25 Sep 2025 02:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB618E0001; Thu, 25 Sep 2025 02:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9C38E0008; Thu, 25 Sep 2025 02:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0B88E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:21:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD4441DED4D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:21:04 +0000 (UTC)
X-FDA: 83926774848.02.7312639
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0739E180006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:21:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ao3y4svZ;
	spf=pass (imf16.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758781263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWVGs+PYKtMTbMr9CAqyDAMYWhTG9d/QRFnGi6Yteos=;
	b=jmTcSAYiHdVf8IJp1HSLThzFeVKZN6agcTu8RW35DDBORwZ2b9wom0LsUWh5PTgYx6LviZ
	FFnm8U5EZijoL5GFGCG1ya9KFVw17OitfgkRoPGfLTS3TgYP2THUKzoHux3nNroWBnFyz6
	50FxSWQe74INgFQYkkA9UyXVKkxD9H4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758781263; a=rsa-sha256;
	cv=none;
	b=iRjpmnK7FJHjs+jFotU82g2yjb3JwOGJ9WE2CGysBbwzJ37LMNZsf/g4GGS1Fcd6vqIQ50
	aSfvIJSzEQCcUzhdqfQrcpGBifsQWKTLxIYdqWqJLfBIYOj0OJyEs8v3mabvHwdIOln5/6
	NjD0pYeuRqH1u+wGzpTdcrO0QGLWVE0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ao3y4svZ;
	spf=pass (imf16.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758781262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MWVGs+PYKtMTbMr9CAqyDAMYWhTG9d/QRFnGi6Yteos=;
	b=Ao3y4svZeOrpQYXP3YYH9BG+ihU92/AYUARP6cOalWWJ0xfFBn9JS7iExuO+wvDOlVHYMF
	HoS2Cj62HuORplkkzRRSqN3+8hJ4NjF/tSRk1dST4V1wsJAtLzT9KA6A/lSCOn3R7hwdhD
	eOkMpL0wbGKObxh/joGi03pZdHndXwU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-x8b2H0wSP5im0fP7tXEa7Q-1; Thu,
 25 Sep 2025 02:20:55 -0400
X-MC-Unique: x8b2H0wSP5im0fP7tXEa7Q-1
X-Mimecast-MFC-AGG-ID: x8b2H0wSP5im0fP7tXEa7Q_1758781253
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1E711955F45;
	Thu, 25 Sep 2025 06:20:52 +0000 (UTC)
Received: from localhost (unknown [10.72.112.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E97CE19560B1;
	Thu, 25 Sep 2025 06:20:50 +0000 (UTC)
Date: Thu, 25 Sep 2025 14:20:46 +0800
From: Baoquan He <bhe@redhat.com>
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, glider@google.com,
	dvyukov@google.com, elver@google.com, linux-mm@kvack.org,
	vincenzo.frascino@arm.com, akpm@linux-foundation.org,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, sj@kernel.org,
	lorenzo.stoakes@oracle.com, christophe.leroy@csgroup.eu
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aNTfPjS2buXMI46D@MiWiFi-R3L-srv>
References: <20250820053459.164825-1-bhe@redhat.com>
 <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv>
 <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com>
 <CA+fCnZf7jYPUyqHqonWhDKVi9eeN6aaaByMTBYCQrv2-8+hngQ@mail.gmail.com>
 <aMfWz4gwFNMx7x82@MiWiFi-R3L-srv>
 <CA+fCnZcWEuBerMeS4RCXQtged06MJhY=55KsYeJEOJn3K0psXQ@mail.gmail.com>
 <aNNY1AzfGua3Kk3S@MiWiFi-R3L-srv>
 <CACzwLxh10=H5LE0p86xKqfvObqq+6ZN5Cs0hJ9i1MKJHWnNx2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACzwLxh10=H5LE0p86xKqfvObqq+6ZN5Cs0hJ9i1MKJHWnNx2w@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0739E180006
X-Stat-Signature: grqic6exjyma9kjkz8msmr38ph9q1bnd
X-Rspam-User: 
X-HE-Tag: 1758781262-343711
X-HE-Meta: U2FsdGVkX18Yzy4CDx4EB5xnm2hIV5SpuKO0Exl2UHmNrd6txC8QnHDsTqAozZAtvbZ0If/fYQwgV6fbg8F/dO0uSrfUTVPUroUAw7DVQDQ4BjY/24qZyh+iKjIrPSpIxU1Gxdqd8iv66KqH1wHPedJvx655iRzX22TGDb9R8HD0qRZcFTBm1gyWSy3o7YLg/bkxczMH3B6dTnm6+m+iDRcJf3a4rk7RrJE/EjiRC/Co7lukD0se+Zw0atV9Q73tk33aid+wFYPJQhGWL+RjIJZLC3m5vj7UwI6WmfA/nAEftLpVgIlganvl0XGeXU/chXSB1kWDoHUHMfFhr8Tne5Xgblr7leW6kxSURtYO7xfxjaUyxcR3l+RJFX3rzB4dwaObiYN++HruYRUkLwUp9wI5ACq73mGRy6SAEeEErAErdceY1VEH9UauLH3EOQTiVAJrLXroDynj/u1+KoHAEUaqnE/S3sLdujnJap/ukXy4CaoGyNLvR57qLc3LQQ8yda7MdyEkOm8mT+NsObt5GFdQXU3kfN8pUc5W3dbs2NZIW7azmEIzjltsfC5uaBw+f0n0mpnaJ4uruMYHX4rRkzTeBkfszk11wPA1mSQp0fTif34ZyjDSur9f1a0dHSNA23zoO52Xgg2DK18yZbezRRNLsNjvEubXx7G3j534dgHe3C2j8kpmv9/fdX7W5x8oYnPMGCc2tGCEFw/cNrslV04g+4UE8KCq/4JQd+rGd2GnbS6F2WkflYsXTBgr8Kp1MhfL6AGNcXncu1BdEIxfG9ABrJNDiq9GOQTtLQuPxiQoOvnkJkUnyf/4zT+VMMea/FhwC+qKV9oEE8ydkWzb5X82dFmj0AAZ30PHy6n7lHzmO0YydSBo7bSMBJ6wy4HyrbYrx6jjYyeCNIGjf0b6Ftlw6wBi8hngvlHRo9KPkzLbIXw0BDX97WIG52e89ppE3UcnqjpqmRO3B3yzo2J
 FU9HKNHp
 4p7uxF5nLCAsPY/46U/YGaJgt0PGrSSa6zGPwK4cbtVKkrG3QD9ckR8oIcgpuisVVwgzlS8u3JlJx2Zr7pipxxGuU9hyi0R3jwiwvWcNZ1/9v+tugy9a3wOyHrCn2u+zgaq5OmQ7epzNvILTD1RIbm2a398yIkskTe7dJ9ePPIArpY0AHqWypYJu4EYs0dJZCDM/XfVjkmE784Z5gWe7NX4vIp9AttjRJImAkhb1obgGGD1G72+9fEnacwPH3uC2PNuN8HPG6yrw8NRmEHba98DVNDi8ww8kTZ/R3S2fS4rzdE927T/O70KZXagOm5BNgAZ1j0FAyINtvW4jTxxvejor/Suv04dry+5uvxIaC3S3rVLI7DvKB5J50yLfU1trkh6FwNpO9Sb3QCroJoVYoPIfCaULGfrvfYO6fr5sMYMnnRvCELMyyeIRZS9yruIDLu/kBqBg3ol3zcvd5KhZbXNO6M8XuaSS31EKCOJRItbnUqEUlpwQ0tVLvenC3WRLaqXZEslKERdX1ss8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/25/25 at 12:07am, Sabyrzhan Tasbolatov wrote:
> On Wed, Sep 24, 2025 at 5:35 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 09/23/25 at 07:49pm, Andrey Konovalov wrote:
> > > Since the Sabyrzhan's patches are already in mm-stable (and I assume
> > > will be merged during the next merge window), just rebase your changes
> > > on top.
> >
> > That's fine, I will rebase.
> >
> > >
> > > But also note that Sabyrzhan is planning to move out the
> > > kasan_enabled() checks into include/linux/kasan.h (which is a clean-up
> > > I would have also asked you to do with the kasan=off patches), so
> > > maybe you should sync up with him wrt these changes.
> >
> > Hi Sabyrzhan,
> >
> > What's your thought? You want to do the cleanup after my rebasing on
> > your merged patches or you prefer to do it ahead of time? Please let me
> > know so that I can adjust my posting accordingly. Thanks.
> >
> 
> Hello,
> 
> I can make all necessary changes only next week. Currently, traveling.
> I will send the fix-up patch Andrey has described somewhere next week.
> Please let me know if it's ok.

Please take it easy, today is Thursday, I will wait for your clean up
patch next week and post. I can do some preparation work for rebasing on
your merged patches. Thanks.

> 
> > Thanks
> > Baoquan
> >
> 


