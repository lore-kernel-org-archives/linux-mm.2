Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD26CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C878E0003; Wed, 22 Oct 2025 14:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B333E8E0002; Wed, 22 Oct 2025 14:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22448E0003; Wed, 22 Oct 2025 14:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9272A8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:31:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09C0C48DF0
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:31:34 +0000 (UTC)
X-FDA: 84026593308.23.B409914
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78BCB120004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:31:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N3m7gE1Z;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761157891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XEn3yyxjXvmC/ldsq8Um3xpfGQ3D0pETvFOoyjoouw8=;
	b=dlO8sUtF7DhBp1FcQDrDho8aVK1kAXNKT8F3Fa6RlERVTxAiy4TK2bi4+J+wA6tVURrJVw
	e0t5/GcqLBVxENAtzIXm6D9Z+hWgPP9sEBRROe+mTQm03GWbsa7f11u3hoYrIEPSpTalMT
	BEBovr+GMxFb/LXq6FxiAF+WO/KT1zA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N3m7gE1Z;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761157891; a=rsa-sha256;
	cv=none;
	b=PCEhrxu/ijcamqzjG/sbPpT2ZPePHl6HpdQ2+5+5/0AOiubgRF2y5BhHl1Jgb6r9a3M7S0
	1nEbH+qZMwQwOFRH9XNtrwe6xmrh3vz94lstrlLyCwtQfne/w+ndQfVh3z48/10YCY8YOT
	lTOaHJPCuzrh17NsEdby4hQ5lnjWU6w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761157890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XEn3yyxjXvmC/ldsq8Um3xpfGQ3D0pETvFOoyjoouw8=;
	b=N3m7gE1ZlAJsHNccyr3qKtSwye/pyyihVmN2QGjeE5AzzHex5RUx8jrBHnR5ZteC2nnlU/
	+d98O3f3X8GrGMPd2H8FsqU3+dGhY75Z+H3a6Nr5k4BL7o9FImktQQvUBZPzHpm9uwePWP
	4d53Czv20uqVWKGvSJDB7GVzPZHmsew=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-Leoe3zDAPvqev1XILZJsdA-1; Wed, 22 Oct 2025 14:31:29 -0400
X-MC-Unique: Leoe3zDAPvqev1XILZJsdA-1
X-Mimecast-MFC-AGG-ID: Leoe3zDAPvqev1XILZJsdA_1761157888
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-427013eb71dso7821627f8f.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:31:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761157888; x=1761762688;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XEn3yyxjXvmC/ldsq8Um3xpfGQ3D0pETvFOoyjoouw8=;
        b=u0IhMNBJ5ZfBmv9271U0DJmqgGdkV1/x0G004hX9qBUu0AB7wP+d0/MvpNSO+1P984
         VX11LLOB+H39t0Y6hgr5qa8HTRGquZBZ9DMSa28UFFrTsVCR6elPHcUEfYwBBcAz9K0s
         mIrg/lkY9sm7kgUur24uZpwDOE8CMggPoN+oigIGxrw83wxoPCSMcqOaVCnaPbPM4GFd
         8ePrHv/LTna49N367xyi/wYo8s6zqgqHhJ2uvKmiWeQ4UHS7okNghsnybgEe2fR40G2x
         PUyPDi0xMkV0oTcpNaCL8RDigfc4J23bdzSLKRpLZs4FzzPqEpJpbdNado90HosshLOz
         DYjw==
X-Forwarded-Encrypted: i=1; AJvYcCVYXH8eL8hbTEStzBuDxCYeHv7SqT+11wakTlEfRSLLfBXxzAoB6XIGFe7MDbWHZJHwgQ23LN8UTA==@kvack.org
X-Gm-Message-State: AOJu0YxMsPYE240Emn9CK13EiHsxr3O7wictGmP/3LxvYBa0x3RIGG3e
	EAjQuhbCYC7sHCpMAXpPmUu2fcLYnxLMUSmq/v9e8lkduKFUWzLsPoM0vtsPY/yXVWfXIP0QJiW
	3CBRNiV79sgedjEYHfD19s8M1cHMt3DAPZiSqAKHsWtkBGHSKaJVO
X-Gm-Gg: ASbGncvOEUudvSCxeDEpXAp7hu9uQ7quXTfCSKak/vt7bwQMhm/PhI0e/zNr/fywwKK
	gIwsSv9UEOtpXxo7fDBL5luw76ksqIZlfznF0d9tqLRABubjRoZ4Aah5DBkpRTY2R1uQHl4YOEV
	X49rmm/lBnghuebkuGELdD+sTTU8bu5u4d8SqZ1vNyndTBjcemso10TBQXkT+PzfzodfokiodUG
	fmEsi5ESryml1TjhCVmrDwhFeJ987VKNTMpQi78ShItMfHyROQED0pMe57dFxrst9E27F9npTE0
	Pdwa2RMt46z/dwiQfPODjhhZS5LA4XILEvoUj3IK3RMpbwg0GMJNtuN42yS1DNZScxVCvBdRjbv
	SG7gTWvOYPCgU36XyFpFdR6tfDopHxTpKYK96DWaVuKlCytbLz34FwfRfapw3LOcpC+yeXc0c6X
	zUfxtQC5LESde5C/LBGqwzTujjdvk=
X-Received: by 2002:a05:6000:2287:b0:3eb:c276:a347 with SMTP id ffacd0b85a97d-42704c6eb76mr14414169f8f.0.1761157888001;
        Wed, 22 Oct 2025 11:31:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2H5mvZbqYjozV89c9xsAvxToHx6BgY2R0vbE6XnaDbrAdEv3Inh8U+0w9UndOHIQ8v68DEw==
X-Received: by 2002:a05:6000:2287:b0:3eb:c276:a347 with SMTP id ffacd0b85a97d-42704c6eb76mr14414145f8f.0.1761157887568;
        Wed, 22 Oct 2025 11:31:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5b3c56sm26481057f8f.18.2025.10.22.11.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 11:31:27 -0700 (PDT)
Message-ID: <d02f6d5f-27fe-459c-a727-3dabcd07ca30@redhat.com>
Date: Wed, 22 Oct 2025 20:31:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/8] mm: Add a ptdesc flag to mark kernel page tables
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
 <20251022082635.2462433-3-baolu.lu@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251022082635.2462433-3-baolu.lu@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S7NAa-86qAEtiSe8_ef7N9uPyi4jTk8p5qndH40Ewno_1761157888
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 78BCB120004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: sw5te8165w5w1t8ursix8q4rjm3d5gud
X-HE-Tag: 1761157891-678336
X-HE-Meta: U2FsdGVkX18ws8mn3Gw9ysuTAh9fBZuoI3mGgZ0HnnchVEAU+FDEAVO+/wWhu4V2B4BX2zJvel/4Mk6VFoFpjtbHjn1gkm+GoOB5W54JfDDBDfu6xps8YqSL3VRKf/8sJWtLRYSwfegYHUj5bO/FX2ZoCk6L0xhmBeAq1bRJ8Ud5cQZ4t43uyrrZ5Vj+KGJQOkqVqiJzN1yQlelLI/v4BLCcIw+b68wmjnGy8JWDQXp9vHY/QGl26bJRhFAIKfQvhv/1rCcD8j58/1BMfdQXb2f9cWsr9RehAZUcx8qavJW9xcrArkKzyD639kEzoT4sx+7SUpGQ+wuNMiSJMkiaDxPHAmlT4ey3ntjK2NAP+DxdVCI+iFLX95EPqNmtsDJmPeiD/7FLzNokCbCroNAqs4d6jFet0XvxB31nQIxhFXCrj6aghen1V4+YdXicJsvPDu68Q8eHhWzL4FoRfKPVKO3+1yn9w3Gms/0KT4vzDEDOhijP4xs+HCviXAx1WsCSTBYhVkxzYT1w3sFNVVfeRD36Z2gTsgzWq0SbuqNx41mgvpHbheb44CpT3RHfOM21LsmW9NJwzln1mCaeXVcl8vYbadF5nVsxbtHWrjrWTbNYW0goowJGCpyzWDycbKJUTjfQGcVirNsB9X1LNjCe0wPj+jZAZGzwwxrKNw9QQyS06sm1hH7iLaLXPE4uqgNprK7iLXntIb/7JqRAJX5yT5m7YthFnBBAXtsc3woNdTAsrr1neba5XyfGgQYBiPEwuH+Xft8SjXUaKtGGf0lBM4HwUkENG8Lu+2bqATyJkLtLEWfpxwItTaK8prIr0Qgvq0cuhx6o9/Cck5INaE0iDDoDVviruD1GEiZQXzSfSRZp2GEnL+F3OZihyCr1WmRB+imAguFDP9bof5fpyPbLvSWlqb3U1nBUgeyg9W9mHAh+P07//XuxOK9vb15511mBX1g2u/H22I1deRmqDQo
 sHm4ZHga
 Amfc45mQIVTYFWsuh8c0131wR5Fdxx5+eGmuZnxLZE3PAhQ+GNX6C5Giz9tnoxpD6kB3CcFuZshJcXKm4KHjdyTrfzv9j7akWcljNRsQVJEe1j8XgH5x2ZLK9FQ18EcDhBZ5Y+Hzcq+pEtl9wXZm/VJrjKHCFJy5SkFea/qUHgbD122WW18NK0vgXRlky9dGmQRKmQ5M1EEUhaj8+6tpAlHFRvVYrydQW5/ENnkkjeVo9mMCe9di0ydg6ANrIfSX7Bzw/tQh1UYepwZV8aP1CoemPfLoObV+tUFkyeyVQOcx7rzd4bPwiWB8zd6fNGMXnaxBwQGLS4GsAcefLxlcWQYof2pZd4V2X0lDXC2jsAzHHmWWEvlLvocR/7g9dGF7wBjvd1tA3tuC/zIjrM+dJcozURQU29SFeRwLOEUmtT1zFVwzYGvgixsvD7W2wSUKaRKjr8N7tqu9Wh082z+L9awqW53CYY/74O5U2euYWz0RIZ2PiigOdJC/fx1/lkn7od158GmGQzpqL9TY3X7exlQIX8vhXr1DLyjU0vofG0A4FD3yKJNXyaX5534j5In8LnHkYIiUhgFobLJA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.10.25 10:26, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The page tables used to map the kernel and userspace often have very
> different handling rules. There are frequently *_kernel() variants of
> functions just for kernel page tables. That's not great and has lead
> to code duplication.
> 
> Instead of having completely separate call paths, allow a 'ptdesc' to
> be marked as being for kernel mappings. Introduce helpers to set and
> clear this status.
> 
> Note: this uses the PG_referenced bit. Page flags are a great fit for
> this since it is truly a single bit of information.  Use PG_referenced
> itself because it's a fairly benign flag (as opposed to things like
> PG_lock). It's also (according to Willy) unlikely to go away any time
> soon.
> 
> PG_referenced is not in PAGE_FLAGS_CHECK_AT_FREE. It does not need to
> be cleared before freeing the page, and pages coming out of the
> allocator should have it cleared. Regardless, introduce an API to
> clear it anyway. Having symmetry in the API makes it easier to change
> the underlying implementation later, like if there was a need to move
> to a PAGE_FLAGS_CHECK_AT_FREE bit.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Just a process thing: if you modified patches such that you are 
considered a co-author, there should probably be a

	Co-developed-by: Lu Baolu <baolu.lu@linux.intel.com>

above your SOB.

See "When to use Acked-by:, Cc:, and Co-developed-by:" in 
Documentation/process/submitting-patches.rst

-- 
Cheers

David / dhildenb


