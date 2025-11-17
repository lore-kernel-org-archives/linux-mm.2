Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA696CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 21:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48ADC8E000A; Mon, 17 Nov 2025 16:05:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462CA8E0005; Mon, 17 Nov 2025 16:05:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FA98E000A; Mon, 17 Nov 2025 16:05:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 259388E0005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:05:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C8671602BD
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:05:46 +0000 (UTC)
X-FDA: 84121330692.02.12DA793
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B301E1C0016
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:05:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mIbGksYJ;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763413544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syA6EtsoQjIRU9LUnEI0MJnDY6mcFjDSRQ05XC6GlgI=;
	b=IBl5cx/MbaxtR7iFmyh+EyGUuJxyCX1Y+pclwUKddrCk/0xr+V+gBoj+cXCbRS+F7/+FcB
	CvOppZmPFDnFwllAkq8S35kdV3iG4Ymkvpg+Z62YGnpt0/KTXcopE7jWNcY6RfoeEtWEoG
	LJyF3eaBotO6edxdmbrkSU/qUwQh5YE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mIbGksYJ;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763413544; a=rsa-sha256;
	cv=none;
	b=7BvLJpo8QPMOWPs/pBcXZUkUj6M8T6Q0uBLMj7Fv9JHcxb10pa3sN34adeUv8eAKX9eG6K
	zkcvh9u9HcVXZNswAi7g157sL6rzudcRjechKVpVxM8GzwvTrfVawmGCZmYHcv1GTyvDrD
	qyOLEropD6LjRx49QYdb1eLNByj97u4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB896605CE;
	Mon, 17 Nov 2025 21:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C9CC19421;
	Mon, 17 Nov 2025 21:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763413543;
	bh=vX0RgenvtHRJqNATnowFhh/xzwC45LGhd8zfOW/YcSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mIbGksYJvNHHKqcnEkxP8edGCkFvrR3zIlacYJ/GfH25Vv7qTIVyrFKH5sk31x0yZ
	 xei+n4/cKhC86cLFzgajOHFrRuzy9Cf4NfBHjUYYpp0CoA35nA6AulbEH6m9QsaiRP
	 j1DTCkXcSjm7izViODv57OuwLXGHry7hOOLvnIWve8ZFi70kPLjCwoPZn/T+iS3iMV
	 rB8SMgpHVZ70/BTPln3obMUZOvsm2vNDyY6atz57c34ZQGgRN69rzy70cjVuaXdMHV
	 Jz6kL5EugQncLiwGz7CwcyM4akaYfMZrA7Dh6fmt85JSxwEixmrs1XXvoRl3A8eWzO
	 2HUdgkejx4kxg==
Date: Mon, 17 Nov 2025 23:05:16 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
Message-ID: <aRuODFfqP-qsxa-j@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-3-pasha.tatashin@soleen.com>
 <aRnG8wDSSAtkEI_z@kernel.org>
 <CA+CK2bDu2FdzyotSwBpGwQtiisv=3f6gC7DzOpebPCxmmpwMYw@mail.gmail.com>
 <aRoi-Pb8jnjaZp0X@kernel.org>
 <CA+CK2bBEs2nr0TmsaV18S-xJTULkobYgv0sU9=RCdReiS0CbPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bBEs2nr0TmsaV18S-xJTULkobYgv0sU9=RCdReiS0CbPQ@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B301E1C0016
X-Stat-Signature: nbuejpir6kz6anjipwpifszmfanymk7b
X-Rspam-User: 
X-HE-Tag: 1763413544-145384
X-HE-Meta: U2FsdGVkX18fPrY1s4FG53QQxsN/PlOP0Rz5h2nZzVYhqBwgAmT+EsoejbDz0fQdsqxIa5cFpdbdGq8FMnEwAiSbBPyCb0IVdMnpHxXXhSYse/NkH3aQHQMT9loocl7ECmP2FZAUd2jFi574ZsrJ/NgMBDUoJtYyFD21zpVEbUQpS8jyni1vH8h+6VBMj7BBJuhNXPO7Nn9toVR1VldXL0Wir9FCWjom7GQSWS0O/QdMDzjEf2xOfsU5JAnxT0IabQG9S8ThB6s1NpbTKeL3T9rYXn54wvnhJqlUjw1ce1YCs0U6RiLdFezxujdbqo2vjqyIGvDbRwx3lToW6mURNeGNkM1tqgnaDS3VRws21eHXYzNPTByMYF6uZaCH0zxIFV7FIJZWF95+GIfF4NRsz87io97x37bwPZD1RrFzFghvRhscUNYI+RVUst0rI7OIxyVyyCewj/WrlP1Vtj6LSJ3uEVCVoGEJ9xy/DxbWQP/fs0rJJMeqCPFKs4aiG0WpbZd01WqNZhtnSaEgdb9Iy0DsMW2ER0JDLuOjI4BVPkPvv7Cw6KL5FJAeYt5uffmL3x2U1vcElGfy2a6ObhtpmupQxoiK4au6BkHHAhjeU+2n+YFEIH1H4OCt7EC0X2eJOHGQwDkBdDkJGPNtrKMl31qCoW1CzyIU1Snb8/qItVvHRBgjyP7BypdSXAqslTl80+eT5TUl9doizplnnPHOHz2HlPDwpez3gtU0Gd+kga7BlLXxrb6jj1BABWJYT6EErzXA4/3ZV5jdxNJBpNdg7BPbPe2G8yHppRAniRsKMIK4dytUPANXHx4o3+6h8nCfc/cqfw5SnVBKuJUBmqsvSrY099sbiXgH3LSy6PdNtPzNvKxX5l9TG6v8fQDj1PbikfpOCQUFGft4vWD3u25mkJ2cRzKcAFSpl0wJFO1HKiDI+j3vjLHN8YbtkUYBMee0vcW9ekhnF3Ar/2LQwGG
 E46gNItA
 GspM8eIBTqZ4iETbURXZHiwkJVYqeUe0ZVPERY9pBWsU+FFbEk4uy3JdfRyDSmlfXRNYgdj1U0TI5Y6+sxMWUhHG0rpx+5xg1E3bgMPVPfAV2UEvPMbRsnvKACtSp+lsmWI+30Z/xElxj+6Utz1zMcgqwSpgiBskZ00BXiqB44i+mO1j/1lFZ84e2jRWLPt++ofjEI+yvKpB0lS/eHfvzCVpRQ+01tS9QTLLxMdvc87p0uzB9dKMWqFipm0JYd49dmhS+wSd9VTUv/omBnpSgo/1AOY/sfIPDrekjz2vjrjkOTa7wQuPAknvgAETEK040BP6fglMkM5JAiYLNZ5gKjbQEipUH/H8NyXhxgFh9wPU3rRRNowG5YGp+8jy8OXmaiMyHXp04sJhxf9npXTb9dMwPOIdnbFzQVoJi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 01:29:47PM -0500, Pasha Tatashin wrote:
> On Sun, Nov 16, 2025 at 2:16 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Sun, Nov 16, 2025 at 09:55:30AM -0500, Pasha Tatashin wrote:
> > > On Sun, Nov 16, 2025 at 7:43 AM Mike Rapoport <rppt@kernel.org> wrote:
> > > >
> > > > > +static int __init liveupdate_early_init(void)
> > > > > +{
> > > > > +     int err;
> > > > > +
> > > > > +     err = luo_early_startup();
> > > > > +     if (err) {
> > > > > +             pr_err("The incoming tree failed to initialize properly [%pe], disabling live update\n",
> > > > > +                    ERR_PTR(err));
> > > >
> > > > How do we report this to the userspace?
> > > > I think the decision what to do in this case belongs there. Even if it's
> > > > down to choosing between plain kexec and full reboot, it's still a policy
> > > > that should be implemented in userspace.
> > >
> > > I agree that policy belongs in userspace, and that is how we designed
> > > it. In this specific failure case (ABI mismatch or corrupt FDT), the
> > > preserved state is unrecoverable by the kernel. We cannot parse the
> > > incoming data, so we cannot offer it to userspace.
> > >
> > > We report this state by not registering the /dev/liveupdate device.
> > > When the userspace agent attempts to initialize, it receives ENOENT.
> > > At that point, the agent exercises its policy:
> > >
> > > - Check dmesg for the specific error and report the failure to the
> > > fleet control plane.
> >
> > Hmm, this is not nice. I think we still should register /dev/liveupdate and
> > let userspace discover this error via /dev/liveupdate ABIs.
> 
> Not registering the device is the correct approach here for two reasons:
> 
> 1. This follows the standard Linux driver pattern. If a driver fails
> to initialize its underlying resources (hardware, firmware, or in this
> case, the incoming FDT), it does not register a character device.
> 2. Registering a "zombie" device that exists solely to return errors
> adds significant complexity. We would need to introduce a specific
> "broken" state to the state machine and add checks to IOCTLs to reject
> commands with a specific error code.

You can avoid that complexity if you register the device with a different
fops, but that's technicality.

Your point about treating the incoming FDT as an underlying resource that
failed to initialize makes sense, but nevertheless userspace needs a
reliable way to detect it and parsing dmesg is not something we should rely
on.

> Pasha

-- 
Sincerely yours,
Mike.

