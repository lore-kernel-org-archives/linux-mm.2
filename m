Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B5EACD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6969E6B0005; Thu,  4 Jun 2026 15:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647AD6B0088; Thu,  4 Jun 2026 15:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 535C56B008A; Thu,  4 Jun 2026 15:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 415316B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:05:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7F0B1A0261
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:05:44 +0000 (UTC)
X-FDA: 84843159408.27.3B51666
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 98C54160007
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:05:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FKdJiaDY;
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780599942;
	b=FQQRTCZHCX9Unv425wTrhu3MvFdiq2SvG391sUF8jREnXki9r6Sm7Fg7pCdLe3fmcp84BR
	KnHF+tiBu9rPpHQI+oHAmOVES9HwAuBCtxDG5cta8Bj8NLfjXtVPw2D7DHin06Dg7YcCue
	JFuLy2CJmBZ7n5Vfu8ejfvzxJLHfWGU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FKdJiaDY;
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780599942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPhPRTQvhTqz157LTAZ7B67TGOApX5jgr9r/KxX7Klk=;
	b=1IYFlC4cwSjZ6qaXV4gDDa6dXj0dDu1qpnQ6hCTxRle9vxb5hHrvRslz3/WywAHkWw+Z1N
	5yPwXEOROoIy0l0+F7iAn5BJOcN7zApuEbQHCUUjHTaBnxF8qkwRKwn1j6FFQxgffd9WSS
	Hpema+KvUJlITVVv6mmKaJqxZUYY314=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-137f18f45dbso954030c88.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 12:05:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780599941; cv=none;
        d=google.com; s=arc-20240605;
        b=cIu3Vn6d9IXCMFBmu/ArOlbdDVsLCIz1fjr6n+T37pOJnyJ5MI82/bQA2X5+b+7wie
         TNsRJK2PzgjSrh9ez2FClLPAwbGUpLwvFprfrIb2oMVgFmjwWHf/CDBMJIoNnKYIviwj
         owpyaWAflAqHNPlMDycCb1k3Od9et/08aVUfNSSaZickX3CR6/C0XNTDU/o06aqkTofL
         oTTHyN6uXOy5eHzaqsnWWrlhHEhLsRdPYhOwj8zajA34K99usoWoRxcmPw7mDojy55Gl
         DrXG5aMj3R1/IhVGdWG5M5acnVTRVcHo/Z7n9to8hT/z7mJiTKS4giKZ/0qZgTKAZAni
         HhbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=fPhPRTQvhTqz157LTAZ7B67TGOApX5jgr9r/KxX7Klk=;
        fh=2CqzE6bgzm5TPX69GEQSm9bpZ+DFrsGVH6y8k7sriq4=;
        b=ao02CayE0SzVU9UuPMXmxeqIt2u4yoK/BfTNemXfhDrebtrWyOv/Cp61Wr4ys+IKg6
         DBy24ph1smPJuPVkKroqkVRatWsEbs3t42wPzqmB5OURvOOKDZmoSdfstuj6Fa7nJNgr
         Wzh8lR/YrGMvtd4E4oYnTTWhHLRAKvtZhPVZaaSwOdNIIBFRthK7C9SmVbaIYgNbEy4J
         dhYYImdQ1m7p0jvvkr04BjUbLYN8ZVEplHGfvgGl4B/Kv9C1+b2Ofb947jBgcktofMVc
         +WQkj8CMrcD66qhXvrcXax944GuQJqVwnwB3qTYgUmJtcfPCCsZ/awKGwqW+4BZueBRU
         vKDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780599941; x=1781204741; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=fPhPRTQvhTqz157LTAZ7B67TGOApX5jgr9r/KxX7Klk=;
        b=FKdJiaDYDoQX7uYNwqSxoYxfJePNonlVn5xY4G3iq/e6dK4Z577b7jDLGKWPzsUJaf
         Yx1AgOCr3lkwi7kWoOzD5wkemKZcCEzsTq9mEDBOhYM2NYpAz4Os0ygVSyi4LkOjOqlq
         XdA64J9JSxcwHsQM3VCoHz7RtHH8zkQRaVtVl3AAKK6px8zqRYnbW4S2rttav2sIaW2E
         Mu5p5ZWSQyd+j0uHKKUKICF8izbGK7BWUSFZARh1Ti35TVIyS8OCiUq7v8F9a0ytIrUt
         w8sVWYrw9Cpxf9W9q3ShTTljgXTWm4A1NA+sF6nSOoGLP/qKwQmNA1gzOfNSRs2mQwBb
         8pPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599941; x=1781204741;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fPhPRTQvhTqz157LTAZ7B67TGOApX5jgr9r/KxX7Klk=;
        b=lCaI4HC18ccQtGBGCgoRaGocyNac0mEJpKJfFbyXeeSTOm7CKH707woF9M+0N53sND
         MszeKOiMNBGn/3tfqTPrGBn7QdowukSVqjXWLr2nzwwUAV2ID/QkVKgnqh7ADhFecDWF
         j55dITygol0EGAkEPt5KJQf6cUQ576vM6y/o4u4QR7hEZDbsMwK3vJ0sc8E7hKhxkWNi
         0DMEda4T6cTGNqdqMh6Tb/ShVPgBmgLCgIqT6Q80XNjvzF4T04YeF3UV8v3qpCTdYhQn
         OLTWkjlJq4xrtZ8b/3M18Nr0/FLU1ckjc315qgDftzx9bjReG/z+jH7Yz1jLO0tLADaU
         g37w==
X-Forwarded-Encrypted: i=1; AFNElJ9boPnrM9HjwgbCbWMTS+B2qxLb7EUF1uJHDEiF3L/W4Jj5aRRer8FcQSbHD7nADkCAPTKKG9n9dg==@kvack.org
X-Gm-Message-State: AOJu0YxWtiYFfU03awb5XbDw083pAv5yk87BKYn5ipi2D+W++Yoz8a0U
	WMVO7exIYet9F8xnjwixaxqPcqli3MnyQiOY1SmeHcDNpoA5XCJ2RIJJqco+EcKeio1YJ2WX/Qy
	Eu11GLBHtOrGnw5zFK3DNSbjIqU0mpwpY4ykdPudT
X-Gm-Gg: Acq92OEh/tn9nWtLY/k+YWflCE/Yp4uf3z3qve5/8MGuS+mwYjOMoXzIExauaniognT
	sjJxpvGoYEXICuQHyrBxWLaGA+syLszSO28maqZVisJ3W4yut0V6UauxG6M4yW9ZvuTsHBZxZPz
	ukSnuj7HEvSiYrNFAN/dc7sObQt+agV57c3i+EJJSsPd9GQzoYBWKK5yi6O4LHV5mn/MyrK1gbo
	g1gJQwE2duOF+91YGpJnJeg6/KuyyW6y/nSWa2d76WjFsmX7DaH7yaIH5HmhjZS3XCybv6BAErH
	xYctX05o9ud7PF967bXpYTIZloytvrf1Mf0w/YnzGoMBFAaUwelKBSUvOVs579+l1jnTbzRYWY7
	SO/22ZP1QrvlSSg==
X-Received: by 2002:a05:7022:fd05:b0:137:64ad:a625 with SMTP id
 a92af1059eb24-1380676002emr151447c88.39.1780599940562; Thu, 04 Jun 2026
 12:05:40 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 4 Jun 2026 12:05:39 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 4 Jun 2026 12:05:39 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <9d15479e-e36b-4865-804c-7d93eb339e4e@arm.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-20-2f0fae496530@google.com> <9d15479e-e36b-4865-804c-7d93eb339e4e@arm.com>
MIME-Version: 1.0
Date: Thu, 4 Jun 2026 12:05:39 -0700
X-Gm-Features: AVHnY4IdCk0L71RC2xDPMs_Z7be_JnLSsAktCF5S5h3trmfsblKVtct2b38am_0
Message-ID: <CAEvNRgF43RBv77RgM67kXRRHDnQw4L5uwQTuvkJHzkHJWB1mag@mail.gmail.com>
Subject: Re: [PATCH v7 20/42] KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE
To: Suzuki K Poulose <suzuki.poulose@arm.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 98C54160007
X-Stat-Signature: gb68f9kjtkewknf6z8febguqu83iogmp
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780599942-131069
X-HE-Meta: U2FsdGVkX19khHr59PLBYpK464BjXvOLW6sXAixyulW5YRGh5ptHG+YMLycpe54+Xrpuj2KsarCFayktxmvPB/Cg2eGEo98F+W1OcrySF43o1B+fjuIFK4TM7JE5ubJWpktuRTB+peHo0s/S/fhS3v9vakuxJ+Ffoo5YxkUpbbjesl565ZZ/ZYL1Vo36Tbp1FE/Pub0ACFTkEo+D1Jxw3KoW5wBCwHJpD2qDRxRGYiLA6hadBqCPTkfKcxneK5s1E99ikAoFfwEodrmKU66R9rVCTm4NxLi1kQ0vDXL6Q2ozyFRS0Cod/nVm3cgM6hadxJ0QS5V/Zg7M/09Uo8bH655lHAl/cunEVZhhqQ9mJ/Ikz42R8UweIsDsDwJITIoj/wHUrxx8+ry5kBrbZU4K0SH1xZ8iiWSol6qqJH6y7yfUbe021CqZ0rEcvMMOet5sUPg/4Rgv4c1Z9UUKtZTN5IEUwi4bPdcbgdjGvHCuESFylqqbNVfSQvTVBK8VAWoohqbm/j6YZeaaukNx/oRmFsfNF3JTcwdCdqp6cUhKX7JttTWAQOdkX9G4XUGE4CRC23zaYqnRKnaRsdmJOLuQco/ptrHZ+IDIQOhsG1Rw2yVHx6jkT3ZI5krhK4PnfbSb3hTfN2xgH+BftPsvMNh7DUyvPF5N3tTOZu2R+akIXF9PtfuuojMSl/I27KCt6R67buQI03ghL161Gr28Gdpo2EtQan0pGaPueFDMSO+tjjbIiPoEU6R5waikpH7Qz7lyKHHe+YnTW5aqux5UruL86nGNCKGxsY+RwmxlzZDOZHaNi7FvmnuZI6q5qqhES18UvxvsYJNUm+duknSFfKGr/mIvv8RWOxUOEB6bA2Q5cw2oYB9G73A2tmI3ZpoESfbRKudkZqb3fYt1txg8ybBo/teTdhR2ZKypfYrnqJaykmGOJq3R/cy2Me9aPvAucoccAIGL13A5LQGYv03rQNP
 UjJOoq0e
 aStFBGix/ZqAT2VyqU47HOt8tZ1K+tCWlejhelapsv81GqfDqL/KCTecxN7ibCQnMFBpQSgwUWbbqwWQC1fMUJJHak0QrG2S2JJj5/db5Vi9xCjxvxyJ3rvbadwZYANYsocZOJtXNwpaRefkCSkyiHY7GaEgJSBmVk24dp6OCTtoR6+j8J/b1fEejck7oXq/Tm4V5UUHPuvi2qwsiuIab/CbPCG0RDgjo/Evt8JEkpIHJyYHJjp7QcEAEap1QmOJuF1zzMSdJsbhNXWePcDKAUiiC4oIhBJqYNxx+LBF15CK07EEivVkJ7PFgv1tEPSVKFG2xh9VE9+eQlg1auJHmZS44HQE75xhW6u6EszluR/aJ9QgGElnhmCrUCqFcSAnEDk4cmSt23AMmaGYjWpRch3PQC4CNyuPNcKfGYXCsSjyzzpsgdxC6y4HftQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

>
> [...snip...]
>
>> +In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO, ``uaddr`` will be
>> +ignored completely. Otherwise, ``uaddr`` is required if
>> +kvm.vm_memory_attributes=1 and optional if kvm.vm_memory_attributes=0, since
>> +in the latter case guest memory can be initialized directly from userspace
>> +prior to converting it to private and passing the GPA range on to this
>> +interface.
>
> Just to confirm, so the sev_gmem_prepare doesn't destroy the contents in
> the process of making it "private" ? i.e., the contents of a SNP shared
> page are preserved while transitioning to "SNP Private" (via RMP
> update).
>
> Suzuki
>

The following is the guest_memfd perspective, I didn't look at the SNP
spec:

Do you mean specifically for KVM_SEV_SNP_PAGE_TYPE_ZERO, or for any
type?

guest_memfd has no plans to do any special zeroing based on type.

guest_memfd decoupled zeroing from preparation a while ago (Michael had
some patches), so zeroing is supposed to be once during folio ownership
by guest_memfd, tracked by the uptodate flag, and preparation is tracked
outside of guest_memfd. So far only SNP does preparation.

>
>
>>
>> [...snip...]
>>

