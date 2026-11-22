Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84747606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=i4DuLXkR
Received: by kanga.kvack.org (Postfix)
	id 922FE6B05B1; Sun, 22 Nov 2026 11:41:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D39E6B05B2; Sun, 22 Nov 2026 11:41:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3526B05B3; Sun, 22 Nov 2026 11:41:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51C3F6B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:41:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF19C1A06E8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:41:48 +0000 (UTC)
X-FDA: 85463321496.05.B773223
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id A5CAE180005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:41:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i4DuLXkR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795365706;
	b=oPG7E3kS/5NzVwyI0RLqwitwhqHVKH5QJJUEp4vW2Be9K0mk5Nl9T7etELd+lMdvwmikkl
	TitrW6N+E57YqNsiSE3Ex7F+zEHkuJf8Cia6HLWeLYpMrgq1fHmmgir2BfVUgqzEXMl4nX
	pTqjgCUtiW9crXTEqwAYGrx3IyLlmdU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795365706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LL3qYOVyI9czVO79Zu0V4wotcvHDG47da4SE8/8wYVY=;
	b=0ZhJWSigSZdMeILvJYahkKO+bBmquMZBnBvt9fbmWL8MXDHRvcEpwbJZR5RuqgGXwL1xh7
	XE8j/XpeRTLbsKa+8JnSdGUyAIub9Hn9Lyu83phFcgjl5mhtxFPIrCSjNnbNBPxO7+enhE
	lkEAoT45VepYi1TFvopQZiF1sNtbu5k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i4DuLXkR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795365705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LL3qYOVyI9czVO79Zu0V4wotcvHDG47da4SE8/8wYVY=;
	b=i4DuLXkRfBoKkPdQMMKa32RW1ogoVjLXgxpWAAn7VsEUXkcDcf25fZfBy5NXFNs/1EV3up
	eriU5xZLLXGAk6Bwu8V8JkwrnUS/x/VChVbc/OodWmCesLUaUBsZKS0ALFxxpUz2kzuH3e
	GgQ4gOEl5P59rDr67zLQTuVdI6kqZw8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-0px6cvo6Nx-IsrJU1GuOKQ-1; Sun, 22 Nov 2026 16:41:43 +0000
X-MC-Unique: 0px6cvo6Nx-IsrJU1GuOKQ-1
X-Mimecast-MFC-AGG-ID: 0px6cvo6Nx-IsrJU1GuOKQ_1795365702
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48e011829easo1450216f8f.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:41:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795365702; x=1795970502;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LL3qYOVyI9czVO79Zu0V4wotcvHDG47da4SE8/8wYVY=;
        b=A7uLfj25LpwNmBRZ0ibK0ZB2byubwGNmJ50QmXHeCKkYOKbw0VjUe6pagoygKum6TP
         QyJaOo07z91QijG5LtbtXKSaMRzzSWJXtmuhLUCakJnUNEoEVDwKG19/x/u7GZNqHhcb
         kogOyQMKJ16kRnsbusvAEiUTG51f0UaZnM973Yohbfvai2RYz9HVTBw64XpyR/oFJTYQ
         /BVB2hAgkPnHTuOUh9oiw4t5e4ebZuy9dbHERBS5BD6fGmnL3p4OEt2jZwleA0Yko2e0
         7E4ABQvqBbT9lZYtpzj9Zq4yKzfl95MU7LQkDmsZDD5z9/cgyORTJvaYgdjVdAydzwfd
         kGZQ==
X-Forwarded-Encrypted: i=1; AL+hErHzg85bMk5icSFHPSV6CbQO45spJObQUhA/3MFPhRvNcQp3KR6I9kaJ9McWuQFL9LUZb8UV4J/NgA==@kvack.org
X-Gm-Message-State: APuU4Z+H0hydrIIHCNSycBMsWuCIB4HrG6xCVEYl8o/5DYwmSVOZwIdn
	OtcEmYpzAivttyVxRBP0NNJIs1MRhQiCzjPsT+IvnQkmhP1VOThYLU7863fkHkjRJbQqW7PMkdR
	MO2bkWjtUCxLap+oyxT1U1Pa2IDVHa5FMf5Bknh/n+t6QAOoQXtY=
X-Gm-Gg: AZFdTZd3GNBmR+QkTF3ZfLPxn+f06/oyxN4z3mfpi4hpbhU50z7Dt8Q919XXq294Zc+
	sXaqbWeM41G4wnCXwLBf8omVtwybdAEk/VJa4DTjjPBiCOp3vT3Py07voG/tO49bQimtbIs2+MC
	CfhNlw/Y1FxQ6PXPw2pef36jIanL4zLkXu3KKS3EYLx7OFL9m61ydIb2qwqd52CHHlfiCx6ZyaJ
	Nt5WSer32uLCOPpY4hFIU9bRU+gtc2IO8Zp+HVXGd05Tgfy37X0ZLtZ3OI9LjrMY28n8nmGem/t
	FlmEsgwqWfrPAg6WgkxAROlRXbIivDe48qfXSAYCZDlGJdg4KNWr9UTGxAuyjnJu1+yvzvVfV+i
	54TvztSGT67nWakBveTXtjMH9JloLVPVUZ85Fc2VEGlCjw+E65bdYqr4VrchEHpfE4nv+V3H8zq
	fVgYtF
X-Received: by 2002:a05:6000:400b:b0:4a8:dbbd:69ab with SMTP id ffacd0b85a97d-4abb4f58c75mr17629627f8f.27.1795365702021;
        Sun, 22 Nov 2026 08:41:42 -0800 (PST)
X-Received: by 2002:a05:6000:400b:b0:4a8:dbbd:69ab with SMTP id ffacd0b85a97d-4abb4f58c75mr17629591f8f.27.1795365701633;
        Sun, 22 Nov 2026 08:41:41 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf62f7sm18809912f8f.13.2026.11.22.08.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 08:41:41 -0800 (PST)
Message-ID: <af91d4a7-11ca-4f84-b8da-33ee1a585916@redhat.com>
Date: Sun, 22 Nov 2026 18:41:39 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
To: Aveline Noir <jm5905938@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, apopple@nvidia.com, balbirs@nvidia.com,
 christian.koenig@amd.com, dri-devel@lists.freedesktop.org,
 Francois Dugast <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org,
 jgg@nvidia.com, jgg@ziepe.ca, leon@kernel.org, leonro@nvidia.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org,
 Patchwork <patchwork@emeril.freedesktop.org>, Shuah Khan <shuah@kernel.org>,
 SeongJae Park <sj@kernel.org>, thomas.hellstrom@linux.intel.com,
 Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com
References: <179342234355.4.16705453209886955762@gmail.com>
 <20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
 <36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
 <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
 <179535872126.34.4789080961796247940.b4-reply@b4>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <179535872126.34.4789080961796247940.b4-reply@b4>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0IdhRCIJOQVdVIfVTqPfLtEucgz0JQYCqaU3vmXMG68_1795365702
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A5CAE180005
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: t5tu4ttef5jc4jcb3weo8o8qiju5ckwg
X-HE-Tag: 1795365705-759631
X-HE-Meta: U2FsdGVkX18YgvO7IpRY4GVq23dQKpBWbo07gOGXr7OVUB6rMRUWm5oC2F49LazmN6JVuFXALWQFJHAoZD1lvf8MoIo/j9Wa0Jk1WeomUwE3iC1oyJL1A2sbj2qrxFBRoFb8NBLbhbILOjJTuGRzOFZSB6vT3MA+Jiy6iNS6AeMBk/L857gnNl5pnug8yNj3F3+h3ImGbihtUMXTK0mfaBmVgIUNnHTa/JXO6NAraLvzkSHJwKdDahFt9NyHc8HKNv4VzXmRzHulnANpoDSlsSHbnhgKQBw3ZYFlR4tDWlk16XH+S27Y18NCGpLoDHVRDI0FRI+0WhzIeUT0NIpNe/6Go80rVNS8CR1OEifhjT8IzLjSqgLld5eZBBrek9q/9JoFtRU/CTztj236MD1rjsuz5RLZb36KsvW5qw/a6AV76CVfCHXo5Em7vIe78Igoco+Q2gr4L0RC7lGhnPOvtqPnsec+yxSehrukjmsyD2UiSWYZMrLIYJwPPljFvDFFZAGcb0IysRTiTpwQdls921c+ZMCC7Yxbhfc5W1jZ/AVqTdtgi9b5tZDKT8irIOxVtTMUTxhLnMIzraElmDDRi/lFxoWPt91kunwWV8XXikzXzzQAGozJJan9xWIRjaeJgsladdcYgNLndET56QfsbDGB99OtdVQIX+6aphAsKrseEE+JgGPdjeRwuGv+Vm6INWTLQb4qA4O6yiC6PJLzkx/xLKnxX9QeOb3v1lPDVhL2jezfbBu7Y+z81srKbzKczTg77dI5imOfLe9CF7bOFiS/6LRkiDJeaGeN0AmojhihQ/7wfvzByqLRbk0zAxk/vEOpqAwerPi8/Vx+tV6T4b1AUglNH5w0RuT2HD60Bqsb/i7Tl+ENGskIHpeuLYi5wZ9g2ndgsDt6hef2DwmTFkDOYCjQNLV8WmDFuRXyOfo8aKcZPOQMN+TUbz5KrOQlzMQrMu+WdsaONXVUw6d
 Ua4AC+ml
 CBRTM4+Fmr5DlqNCgZgWgdNz/NfGpaNSQaTtn9srponPmy+FfA+AIIENX+pXdnD20MCusCXQ+Rt4bow0BNYNFxs0UtQ/mZNwL5054Uw+XAX+HMnSvHEQdXee8QQ5qAz08kYWeQIQWtH+nkqnrUeIUNp9z6LwFBAaq5RH1UKmkTGD2//AvSSx76Y6tZSLKHOxyMHl4kXyF0F+xdFh785Czf5Knu2O6gbuLxbizl1B+ujcSa8jsCCFS6ioGKtdIl8ROYj8LMiBAEV+OtL/dRS9M6qjEwtbgYxWqKj2j2C/QIF9W38tYWQ5CBQyCLpPSGf16XJs3MoIQ8av57CFlum2HdnEIKoqkEbswT6VODoqGn8nmLIDK/gVc6tC6Myy3ZEeeWlF8oTSeX8gBjbAU4dQupZ3LVdZsDUz13xMUCp9h+7X4/HyytMOIBaaxuHEGtv1WNoKOH4v3TXuzAa4inpoRpedffWiuDMvDIKZ9W60ADOEP8eQE0DPdjYXmPEcr6B14277QtaBclAByOYZINHRH8t6+1YL29o8TFxThlaIkRfXOK7EqxneiEuII/NkwOsZiZH6HzH/ut+VZj26d1HRmSC4bMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/22/26 16:45, Aveline Noir wrote:

> Hi Andrew,
>
> On Sun, 22 Nov 2026 01:52:46 -0800 Andrew Morton wrote:
>
>> Store the corresponding RAM backing page instead.
> This avoids the oops on the first read through the second descriptor,
> but leaves a stale backing page pointer after CPU faultback.
>
> Since the mirror XArray entries don't take a page reference, they rely
> on invalidation.  When the CPU later faults the page back to RAM,
> dmirror_interval_invalidate() skips MMU_NOTIFY_MIGRATE for the same
> mdevice, and dmirror_devmem_fault_alloc_and_copy() only clears the
> migrating descriptor's entry before the backing folio is freed.  The
> second descriptor still points to that freed backing page.
>
> Reading the same page again through the second descriptor in QEMU
> triggers a KASAN use-after-free in dmirror_do_read(), and the read
> returns the stale data instead of what the CPU wrote.

I think this is right, but a fairly artificial scenario: it needs two
descriptors open on the same test device in one test, a migration through one,
a read through the other, a CPU fault back, and then another read through
the second descriptor..

The fix lets the device private page content be read without an oops
in the context of one fd which is an improvement. 


>
> The second descriptor's entry probably needs to be invalidated before
> the backing page is freed, and it'd be nice to cover a second read
> after faultback in the selftest too.
>
> Thanks,
> Aveline Noir

--Mika


