Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1B90CD5BB5
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2F66B00B5; Thu, 21 May 2026 10:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A41D6B00BA; Thu, 21 May 2026 10:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C2F6B00DA; Thu, 21 May 2026 10:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E59DF6B00B5
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:36:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC5A8C1C4D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:36:46 +0000 (UTC)
X-FDA: 84791678412.13.0CA1722
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id A12B4A0013
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:36:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DQDdD5dY;
	spf=pass (imf15.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vYaUa4IMCMaYAyZ5spn416wLAd7Y4Wm0XOOfJ/wi8IE=;
	b=CYt8wvj5nl68jBzTXU7luYAhPnTXPMhg2a66Io9XJLeUi/2MDN2gAcSKU6ysDukQpOnOw+
	VkDLP6qs1Zo6orVXvocpm9Lni2sVkGKSC8y6fOXKWs647nNA+DlB9xfB6CMdV4G9zk0mFu
	4+8Tbp3XuCi/cwouHk1D35kDvzMwRzs=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DQDdD5dY;
	spf=pass (imf15.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779374204; a=rsa-sha256;
	cv=pass;
	b=6UZVHoYmOoa427TOQfFXtLq/Sj815psu7lm9szJp0qvFK5ARAfN8eX3oWEEkNAyCc0VjMU
	H6N+ZDirhgBlcn5Bn8BdOpMSiG+WXfpNrxoUKbOvj6OR2qE+ZWLe//aBeFD3h8XIOG7I8N
	kln066VYcc2WR1Ihf297sbazUCNL3aA=
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-575212eb419so4428600e0c.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 07:36:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779374204; cv=none;
        d=google.com; s=arc-20240605;
        b=Yiwefjo24LIrMpwNlfbYait82YC9yeZxF3pKF9x23mSsIN2EOu9xA7sC9+Tu43MePQ
         EuRm196eKAQCIcllI/7Om4ltZubaOBIymYndcPtbv5kwubnk+ruQN3KpPwBEGWvY/KYw
         c/LNo0JgcdaLdJQI/RJFx5wafeC9M8IiTL43PwSZd3u/n+txoEzpkqNC4HtEe6Rz3eoU
         6/tA3e6obHxShGag3yL6V6Bzr/ceYwNHK2qFl9iay/gxg9UNkxC0kAHPKrSUd/BGXuzW
         MK/1/mnYFHDTrCynICr4R9Rt1MtkoELKEH8u/OcP0Cy5lctLDmwX4eZgI3Q0w3b8UOny
         HQTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=vYaUa4IMCMaYAyZ5spn416wLAd7Y4Wm0XOOfJ/wi8IE=;
        fh=z4tmuQktCH+Tsfh1J+6HzyEHihv77zi4pTf0ntl+ZX0=;
        b=YWWomcED5eD6vE8UJTDxdox/UcEzxBvmD4PEhj1fURlkvyTK+jEi6XJRJiuX1zy9Z2
         /2bGVG2eirn6R1SnV8oW0Q+Q7ilshIekZjMtVPlUVxtRyC+sTFneVmq2+hoX60GL7hI5
         oM1i7lv3d8EoH1/OBTs+TvsW7I7CK2wpIOoRAq5tDSAC0bXkIP/nFuj+/39K9P6yDPUf
         8nScZWP03H1uJMqGz8O4Xbzdkyd3yalXObbod9s8YimY1mV6THkkKnSIC1x5KsQszdZi
         TH2A9H120A6y676gn3azbeIfqUNMnOpR3zhLVWE9AFUNx1OoBdCu0izlrT3FpQOKKa8v
         dweQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779374204; x=1779979004; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=vYaUa4IMCMaYAyZ5spn416wLAd7Y4Wm0XOOfJ/wi8IE=;
        b=DQDdD5dYZ4CzvzhV+3qfrgdIY1llGanTFkiu7awO5Vmw/V2FvVnicVU4nnHYmUpTkB
         PAxo8iHydEiPFY3G5m3/IQmwHCZU9d9D7+UU/gj+O2ndGUSmupyurxGftTe5cKr2PKka
         FfVSxhkDdAWY17UaB3VfSlep7oFvK346GXH2JJHfEp3ivp+N4+NUDAmRasobb1cy0IsV
         a9twiNau03AMVLa52Hz9cIl65/PuTexcNRSilqYjW4OxnRZE0Rw5mMsNMvjWt8bYk9Bx
         zqO8TZbPH4xI560cRuMbG2k+0M1NgaLoUuKT4totW0EjLT4s64oVaWDoD9ORYA9W9V6C
         STzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779374204; x=1779979004;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vYaUa4IMCMaYAyZ5spn416wLAd7Y4Wm0XOOfJ/wi8IE=;
        b=kkwRGaTreoPoILfnMwqVyw4Lq19iLNHFAqzsYecc/U2lcgjsh4q9KJVDdyo0jeFz6o
         RKS4rYIuQbfxMEqbuKGvKf5Uz5P2J3htJHKJJx5Z5XbKQEzDk5HQZ6JdgY6c1Rz0K6N1
         5AVLpX5uWo6RRwN9BCRWFbwm52VgJWS09EuTLTAXKwzhVQC9CntYXizepw4vIc5tNn8h
         0HoBicJOUz9LpzbzG6PRz380YpYL+TxHUG1Ac3XskUCw2xqxWXOlKtV5oNmXDBq/RDft
         7+A2oYfS1Y8Zp3m3LRtBFbjMqPKhu7ZPE/9kdKOXfXrTT2x/dRM4alnI5anQQL+kYpNR
         LGBw==
X-Forwarded-Encrypted: i=1; AFNElJ8nlfTtey62e9oyWaIL7fvjZ/eTCh4bDwwkDsmgweCYeyTGXOHjfZjgKTqVR8CMnya3JOYVNXNEWA==@kvack.org
X-Gm-Message-State: AOJu0YxOydsscjsCBGI3/92FlqjvD2XKBAg9FL05RvZq+ek/a+XfmDxY
	+NNRBBLwqTpSav41y8vzhehbwz4XNJ2MFnwJ5PcnQjTA+vPI2Zj3UjNWJaexXXQBIKjj/fvAKMQ
	ZsYzKFCxp3Jb844fKGPoC+rVQ3rJsn6H63qAi9IdO
X-Gm-Gg: Acq92OE0U1GRTYBZBGHPhEiO4Lj9WEgLHHAhVFZX3PyaEJ3zXeJ+7t82OyIbDErXwhj
	1PCUuc1RZeRKrLC8Iknkf99eC8hGyaGrwSTECFJqLMWqR9zVThBAhWzT/7AZh76reuU2/IhkeX5
	pPY5IiRwRajYS3q91XJOXrsYV5vsqyZrDe1PSk/Yc6F1RH+9wh7rNSXz/pMWHzAU7SCZRvZoge1
	UcjbA+jB1HXXxUWIR1B/b0OIRi+PCOmutw3gA4pQiFsnNiKvgRnInCNeg1+lzrq9eVXwzhNVirL
	jcpF0K99DbuUCJjZlA81qQNlMgVDERCWug/XZN5mAUQsWs9ATQ==
X-Received: by 2002:ac5:ce81:0:b0:575:a69a:a3c0 with SMTP id
 71dfb90a1353d-58412b0d22amr1255230e0c.7.1779374203234; Thu, 21 May 2026
 07:36:43 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 21 May 2026 07:36:42 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 21 May 2026 07:36:42 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CA+EHjTyaBpTYsJRRyP09YggoHbi6s-ZgDoWoFgDRxO5k_BkoBw@mail.gmail.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-11-91ab5a8b19a4@google.com> <CA+EHjTyaBpTYsJRRyP09YggoHbi6s-ZgDoWoFgDRxO5k_BkoBw@mail.gmail.com>
MIME-Version: 1.0
Date: Thu, 21 May 2026 07:36:42 -0700
X-Gm-Features: AVHnY4I30lxiEW6e6I5WKrwyQmuhxKDxlslbMLBEy4dCPODuZC6olFnz0j666eA
Message-ID: <CAEvNRgHBwVx+biHxTyNETBt1jQ9Fohshud1N4bt8beVYhPiOKA@mail.gmail.com>
Subject: Re: [PATCH v6 11/43] KVM: guest_memfd: Ensure pages are not in use
 before conversion
To: Fuad Tabba <tabba@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
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
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A12B4A0013
X-Stat-Signature: 5our7xth6ep4xa3anxuudrttsi5qhmh5
X-HE-Tag: 1779374204-131986
X-HE-Meta: U2FsdGVkX19aUl4Hf30Y6pZIukqmGUsRFxuLcNfv0z0F9h+XIQe45rZLRio7SrpK6qDcVPSLOL2EVQndsfG9R4cFgqEeyA0mCsD+US/4E3ELtjGuI1mCHDM/MS5aA4fwpvH1LwzincKMpR8BCWtEO3cTE97UYAtYMprG0OMfpGPhXk6ywhEMMagFCFiojzQuoQu8JSdgH1aGc4r+9Lwb5cnBeZLIxxqr8I6R1Js0uNFG+WpXF4YFGnXgAIoopPkYGL2XIJfSFASphjSrFVwBY6jag9Sfg2j3AFloCXu1AXd1ddMDVrePwTtA6nKdxX+3qU9JNBkP/QWjUORyddglDs1j/Lp2p2bM+jBfj7HeEVmw8cB3gquyQv7hhLxa1zDn8K5GLC6M82oqynqULCaLxgWDvbVg/rziKm/EQ6Oxyn6RExYjuZhSM2fw+U5SVzQcfcYgNrq+S4fPpXDJ/FgMmzCHHN6B1K/2u7eRKEJK6Bz4K9AnFMJ0+WR4jQq6VkfuGFjVOYE/Vma+jkF6oQ37kdiSmB7Y+kJaKQ29WHUEv0A55iIgWSfyLTcttm8aST7ljkvdmfrWO2HXEr+ekG3v2dRdlQ8rYav2UJvpWBXeBBgT7vlXXTWxW6MSiirAbmlA9XQyCQri+ryte0WCm1JWDQn2y3dV5R3QUzrTiG4IhrHQi8UAh3lMG/rn9blhLizy2jj6xJ309LZQJv17QhfObZEDzublwrr9AaZXM0TnND8u//AlMKGX+KtcG5o1ExtzP5/IYsSw+k1sdu6JEQVnWA6bUSLzDuubKZmpObDz1Gcf63bIJwBMmsnGTVdoj0owuBUETGgLOH0vw/xzfrn4Vrzzo1ZDfGiSgAdBkWPtBcfHARU3G5fl5+YmhkXlIK7XtnqeMS2q31Gow7+l7bnBS0YPw0b/31mQzPz3LROBuN7pG9rni35WcHNLpDMedOGurwGVrf2dGZGYur4COdf
 QxGGrPni
 Cge5l7PvwEshKTlnCEuc2Rj/dQSZS76TeSf5f/kIvD+59sA0PVR1qjLc+OE4P/uIOXhVHSCQP1E4hslI5zeymmZVVwVuIqcB2+0Ms4iZ3AlMGbcixVVDCOTw+YS01lVy9A1r/O36yMUkDaYXqnU6PX9BVw2OkgpOgVZYGhSSq7Kve19LDG/WJhM/uB42+D7WIL9KP/igD4wIFDQFtbN7a/UQkLKEN2ylJbxERnA/Q/WkSAp8OeBgk2iuq6ANG/OcC/gQo/94LnzbUGfbp2THZEHyvcO4yyam/ZEDghY7VbMNu/xgJqktSjwTAOThm3JW1+ct4lxx26w4bt3X9E/RPYGc31KG03g/QE3unorA6gh9s4wb8OLWxZ3OkeXmurKzbPgkDDL2M9QsjBFqOZvhDXYN4l7wXSU8ZQQ/Nzpwh3oRenmKeHpBFboeSQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fuad Tabba <tabba@google.com> writes:

>
> [...snip...]
>
>> +static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>> +                                           size_t nr_pages, pgoff_t *err_index)
>> +{
>> +       struct address_space *mapping = inode->i_mapping;
>> +       const int filemap_get_folios_refcount = 1;
>> +       pgoff_t last = start + nr_pages - 1;
>> +       struct folio_batch fbatch;
>> +       bool safe = true;
>> +       int i;
>> +
>> +       folio_batch_init(&fbatch);
>> +       while (safe && filemap_get_folios(mapping, &start, last, &fbatch)) {
>> +
>> +               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
>> +                       struct folio *folio = fbatch.folios[i];
>> +
>> +                       if (folio_ref_count(folio) !=
>> +                           folio_nr_pages(folio) + filemap_get_folios_refcount) {
>> +                               safe = false;
>> +                               *err_index = folio->index;
>> +                               break;
>
> https://sashiko.dev/#/patchset/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4%40google.com?part=11
>

Sashiko's first issue on lru is addressed in a separate patch later. :)

> Sashiko raised a few issues here, but I think this one might be
> genuine. Can you look into it please?
>
> If that's right, when huge page support lands, if start falls in the
> middle of a large folio, returning folio->index as the err_index will
> return an offset strictly less than the requested start. A naive
> userspace retry loop resuming from error_offset would step backwards
> and corrupt attributes on memory it didn't intend to convert.
> err_index should be clamped to max(start, folio->index).
>

For these ones, I was thinking to defer all the huge-page related issues
to be fixed when huge pages land, since there are probably quite a few
places to update.

On second thought, this isn't a huge change, I'll fix this in the next
revision.

> Cheers,
> /fuad
>
>> +                       }
>> +               }
>> +
>>
>> [...snip...]
>>

