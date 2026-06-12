Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F7BDCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 05:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1286B00A0; Fri, 12 Jun 2026 01:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051C46B00A1; Fri, 12 Jun 2026 01:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA396B00A2; Fri, 12 Jun 2026 01:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D95B26B00A0
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:24:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A2791C3851
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:24:31 +0000 (UTC)
X-FDA: 84870120342.29.EBDAAA6
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6186520003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:24:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DPM7ZoCv;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of wqu@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=wqu@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781241869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mY8Ko1A+P6AJEypWSmExtdmu6Mefh9vM6dtIhppSYs=;
	b=5DYNIY4fdEj+Yy6INGmF7ZjywDmSnoa2A/SXFdGsiQmGx3fINqjg39xQ2aAD3djZo+nA1a
	hfRMv3ExDvfmp1G/fAkk0zUrp+Kva8LPKScWH+0l7Ghqowf+vuuEyf4HqkuSNa2EaMySsV
	b3wM9fthRMDSyvajObDEKfIysH3EGWA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DPM7ZoCv;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of wqu@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=wqu@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781241869;
	b=7cfOHerh2bJ9fz3WWQAD1+L8Mzpdz2rlSO7cmd62l8EioxBYNAdidcU6C7Biqn7rLAQorV
	VFO6LRD8J+6FBLG30SL97CgHR1oDpCW+3mEFqv0V997bcIRkUO9+2NCOPiHtogMKodW02K
	YfcyepMGYY8VlirFyeeCqGTXfeLlS+c=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490d1e54b3bso6103795e9.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781241868; x=1781846668; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9mY8Ko1A+P6AJEypWSmExtdmu6Mefh9vM6dtIhppSYs=;
        b=DPM7ZoCvL0YQkBVOSQmOSwZJDtAu4OKlBf8cy7uoSYdNwP2wBbNsu/A4OtZia693DR
         sJZqhEwpN3/k/z9I6phZ7gEpRAkF7neR8I2zisdrNcr2yvsBoAGuCt59t3C2SA5ZUtk7
         CWcCwUgw8yq/5dt4vZt2nsUp3BS0V0qTytXbibcRZ2gMw3pEXdTZ9F4Efm0k23ApvWEq
         +cf8dN12ni4DyFDc6kSOPPykYdxFaUTIPdQMKR7qagCdvt8JS6SXSHrBOVOSifrXnfcd
         uXNXwZ1ECUCoLqYF7cHh27Phht7Cy5IROe4b46mt5ZHuscNrb+iOZoZ0w9ZPVEUIkvtx
         4kGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781241868; x=1781846668;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9mY8Ko1A+P6AJEypWSmExtdmu6Mefh9vM6dtIhppSYs=;
        b=F21cZUhfGVyGT25sb+ys8MPSWuKOVFwD/LbX2HajLMJLS0VyFedOKOZMXFhCVDBt61
         iVIg34pJ5p6aLFLgfjA1A8IpEtNHx9Rmmk92U808hymBiwPOdKz1wAj61KWXzsA30Oiq
         a++jaAOCECRTt/qLf4RGHQjt6jJTVPdusjjW/bREUIjsq5KoSn7WbwAM2RlVx3+AvfsF
         mSZ9PKdy7aiM04BoXfct1LaUR8Lh26wBLDq4e4Ir3euE9SbUzJ7TJ6VcAYZDQ7tThEL2
         BiaCoLtx5ZIK0grPYL6sCEhiK0c23JlwgWmrzS7hBBEF7Xt7wzbV9CJjNn0HkqCEoK9W
         Srgg==
X-Forwarded-Encrypted: i=1; AFNElJ/bqQPXKJKbdXl8rDytNQDYHTILa52Cc77ttrYsBFs8XG0B8YhvwQ06UasTd2zabKZ7D5naVtT60w==@kvack.org
X-Gm-Message-State: AOJu0Yxsh2o6iQAau+PVRkbzL1MEI4hbn+caim0aaw4f6cuJnQ1jfj6Q
	Us9H3ADTu0Z52u8a1AdoikDWCLWBADMylLSkpaMIr7WX5JyDkXc8Z08Y/QD/S0ztthA=
X-Gm-Gg: Acq92OHklqb2O61hZNjOn2moLLH8mQ4VdNikpdLhpZgajfbci0IugMgaSdRZyocOnaB
	LlV69uJ1YZ/lcyHbi860vPHgrR8HgaOk3vEjZEBWzl2ALisYUL3BYDhDFllVpHGnljn1RqBu8BL
	zNFVoxQV28JlRukTsbnepWp/P0VwrXiRkpdpoZd6FCPs9bfZ7qIKDxsmWb2XH9zLO07DkOWBudB
	QCxuUCXJsQgNshKr9PL0/zPW6KuWkYB8x3mThljKh55z4QJpUH8AjqMfES/B6bGKfHecvUaLD+Y
	YczO7Nz+DQU93VTFwUu0M83U2Z5JF9c25o/VPCe+f/2OfdWCMUJmR9l6Rw1V6GUxtFo4IY3yfSO
	2x59u/iJCg/n7wRfxgHB0ERkInOlTx97FgBvSaVm5zgaiWPIHX5nNXDDu5bYTei2u7ypgyFY9UY
	FMkSK3KSjXXu4vrn8LfBOMlfgmCD7HmFax35z4fwU4ueGVAZUFKuuVkoI/aqBHSan4+cOGGhMt8
	gNvGZBhhiUgkKzEmijAGt8iz7VQufx0uXWrmUubPGRfZw==
X-Received: by 2002:a05:600c:8b44:b0:490:b65f:8b1 with SMTP id 5b1f17b1804b1-490ec4992b5mr11700415e9.5.1781241867773;
        Thu, 11 Jun 2026 22:24:27 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c433557c47sm6928115ad.79.2026.06.11.22.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 22:24:26 -0700 (PDT)
Message-ID: <f1dbdcd6-4e6e-4304-8fa5-59c2c60252ad@suse.com>
Date: Fri, 12 Jun 2026 14:54:22 +0930
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Direct IO page bouncing got some garbage?
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <b866b2e6-292f-4c5e-ae5a-d77e983cfefd@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <b866b2e6-292f-4c5e-ae5a-d77e983cfefd@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6186520003
X-Stat-Signature: 4riuf38jradjubu1s635pzmxnoqbe9ux
X-Rspam-User: 
X-HE-Tag: 1781241869-752199
X-HE-Meta: U2FsdGVkX1+Co9fe4Uj3Xztd7lm4aymmxkXTWH3cHqy6P7gGy5YW1s8xIFkdPwwVUB6yWRiPQQGTy+emb0alZXn84SznIFBCBEQupHcvmoPGHhk6uiwCjjEGdF6tJfM5Wj50fb2CNliPtMic+NjEpPsrjGOuqFFMnxTq8PDA/BSrn+ZgYyLEzG4rQJyIiTEyBxWw78HddCjfTL+nKLBhrQy2X0FfNPmAKWs4/TbGERFC9gB/f9DZc3HljanaAoK9j9EsucAHH386djs7dn6nZJogm7GsHFxOURthd71CWgvztkkqgkl58rvnIzUApzAdd9ry20QHQFEZPleiTuf2JinJhlKVI8GCBTX/SHSKfM4LFiTbZzDF0EexSK1mCiqH6hE2+jpoGvtde7CnS+THbx794GRZSbFFj2eyJ6w7MKJoMVNUPbtc0gsJ4HW3LKFCKnoF01FkeTRa4viud5J4p0WUUHdrp8V0Y0Et+uJa9PqrwiVfzecOhcn3bDMPc5unQoiu8yTHgIT4P5WlU1Oo3GwNmRJNWMejp08ZR2LQM/wvzX2fPVQZ05DiMz8inT5loQk6HoA0RZdfzQkhVyeuwEAEK/EWPARekGo2Q4tx/awoEjaoSzczScZ1InXnvsE9dbAXtGNynzf9IKeCmad2yp3s3/kY9r8WUPsFUfw7Dl8lB0xb8MSRr8w3Ycpt3kBF84Pzmp0yv9JgNk134eDv0SAnwDZZT4p27J8HYtoDh5RoyvjYmWsQw3aYK1fkjSBBrwGYsf/R9cbM8x9qmeWz/yLyA0AYy4m4LY1xkTSweM0XCFtVj1kLEFSAr6iTb37Zzl5auVEKbTfMm75o0VcIwYM532sMHHwX+1ZuKz4l1kixazdwIt/BUgtB7W6dzluC3V8bricqdIEvU1Wj81OUFy59OQfcmIb0KZjU+XWH8GApjexKDWISBZzj+ZJ6ecAyYMv3lOmWmVM7pO2wXOh
 Ti8HbTBB
 lHolqIwp33SKAD3X2TXawLNjLdSddrHvus6Y1KuXh2YymJ2pPBBjwdkY5Epa8xLhBCUWqLRsNwmCkiLR5U6Jalk3bpL3U8GJ556PQmsOjOBHrIT/5Qtd+PJ43QHIlPZPm6wX9+/cWJRt8Do8y63yf/AxmbZZJMTMaFC1/DuXi4q1VG/G2I1FD5wPPfDO0843UyD9zSXzkxGT7ChxO6wmYuE5LU0ArWeCK95/aIo0DCBH4jwjWXxXIEmXlOk9EM3m/cYc0XmrcSLbB8TllWiK9IiWr9EEtXDrDvIu3/LJ4ubXouP1WtB8cLdkdq+yuI7jCilMPT2c7KX3H5Fy0XqNdJ5yMYGtA7JvZgQ3OhrWrd1izQ/bJ5QQZk875EAwR0WoQzXaKDTLMiTXPExis6Eg+jV1G8Fsj5Wk3opPJHzkT2pSxjGRz4x1e/N53l6kyhxecbPIF5L+qFoRsS33pk861h9Vx1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/12 11:11, Qu Wenruo 写道:
> Hi,
> 
> Recently I'm trying to make btrfs utilize IOMAP_DIO_BOUNCE, however I'm 
> experiencing weird data corruption.
> 
> During test case generic/708, I'm reliably hitting garbage pages at the 
> last 64KiB, the garbage even contains an ELF header.

Added ftrace shows that, since btrfs has to disable page fault to avoid 
certain deadlock, bio_iov_iter_bounced() failed with a short copy.

Initially bio_iov_iter_bounced() got a 1MiB page, but copy_iter_from() 
only copied 64K then failed due to the disabled page fault.

I don't think it's a coincident that the short 64K exactly matches where 
the garbage is (the last 64K).

I guess it's in the error path we didn't properly revert the iov iter?

> 
> In that test case, we mmap a 2MiB sized buffer from another file, and 
> use that 2MiB mmapped memory as buffer for direct IO, write into a 
> different file.
> 
> The source file has dirty page cache for that 2MiB range, and no 
> writeback happened during that direct IO write.
> 
> So it means as long as we fault in all the pages of that 2MiB buffer, we 
> should be able to copy them into the newly allocated folio, and submit a 
> bio using the bounced pages.
> 
> But the last 64KiB is reliably corrupted with some ELF header.
> 
> I'm wondering where the corruption is from, especially it seems btrfs 
> has very little to do, except calling fault_in_iov_readable() to fault 
> in all the pages.
> 
> Thanks,
> Qu


