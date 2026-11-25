Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9D7606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 00:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ICImlDJb
Received: by kanga.kvack.org (Postfix)
	id EAD0A6B08BD; Tue, 24 Nov 2026 19:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E516B08BF; Tue, 24 Nov 2026 19:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4C496B08C0; Tue, 24 Nov 2026 19:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9E466B08BD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:39:57 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32D7E8065F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:39:57 +0000 (UTC)
X-FDA: 85471784034.12.78EA9C9
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3F7841C000C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:39:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ICImlDJb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795567195;
	b=Vv+vzJM9Lfn0Gqf4Da1ENJR2h/dH5/j1UBAQEfEyke04ui/gp/68Oi8D9BMCoA+nO9+JzQ
	w+npT7CVf/KThpGCqm1U+8+bovsq8g2ZzwBWtRX0m1YkrcENaTwS8JhrN6aSOrsSrXYjRn
	AA2F7yQseFF38O61pUwhQQRsDXjdJv4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795567195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YKxHcqUXjQp/1J5J8B8/Kkrmh8UptW8ucEK7buHNuos=;
	b=BgNCXzrxOlywU89riBp0CY6gVUo4ZnMQ2tQuw+cVH3+iSguf6wDUFOeg/0lfRsqOMM4E6p
	xywqRH2CTZPHBY8mmowOUghakwjA5FLN1D0jXM4ZBHAlc1c7qgtrkSCjUUDoXrZsXSn1q4
	N8ZGtJO7zYQ1IQe3fRWCa28oIdXEdi4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ICImlDJb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2f03920c4a0so32664495ad.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795567194; x=1796171994; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YKxHcqUXjQp/1J5J8B8/Kkrmh8UptW8ucEK7buHNuos=;
        b=ICImlDJbCyIQDYAmWP1t5xKNrVpT/7mpzxfFFiOgvNg4hbRCYLByNMIUa35VZf/KhG
         odzcwfI5VEKwHrtXAaGQaxM/S0QwBeTwaygynchgTZX1VDjNvdJZuZ3HNRgBvRN9wf+d
         TH4agzT5kc4C0o8UpVr5qKM8fyGCmdOVZJTBDse1I0HoY5vumJP+NB9Bg6GsC0/5OsZL
         PqGNmxnYP15t3RzsXcKO5nSlZ+5SQzcrVEXorYWPxxZZe3wnott4Na2DDSPbYPQB/VBL
         tT7rNi5C9tsdVlFLEVdAhuIcnGl1MQNRgkXccnlnFEcz3iiqk91C4/1psTCyxHEVjLty
         ++TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795567194; x=1796171994;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YKxHcqUXjQp/1J5J8B8/Kkrmh8UptW8ucEK7buHNuos=;
        b=2CuK37DHPc7tYPwOp22squ/T5xQehdFX4TaUAu9C1XbsGbeU14hyWknswHx0jVIeI9
         UJyea0Ro3p21u+a8SszwrCfkQyFkEiq7PESrgaExApd1R1iCJDQi4Z+EZotvLg+cvvwE
         T8EeGi2anX+9+pTURs7cBoYqXklJvJQ3eXRCkcIL/4apFTZ90Idh/AzUJB9BnoRYzy7G
         nmcYLG32avcwk+9kZzSIipYWDCa0zNCHvTMCes2Vldk/jgsHavkl6+4b/it6ZeYV4myw
         x/jJXEPJJLLLdxU/MiMwdT2IXX8cy2nTguQ/mMWMK3Qv8RvlV0qaQcYk4pn34GrG7Zt0
         8R0w==
X-Forwarded-Encrypted: i=1; AL+hErEMYh/jjgOnIqRCR/4Ej3oLGXrgIiJliITyY+HT2NLh6Mrkukk08EBw94Au/7+cpABYvy3+dE22WA==@kvack.org
X-Gm-Message-State: APuU4Z/qad3+/k7PShIMf9MeWFEzn+syM7p4L+q0mIaQ3OjsrRVjPq9Z
	qxwhS72bAZV8Em1HBz9nYfQKp3FCgDninihxr9LH0xGbxtRzsc7KIPMAQhkF0Z6GKw==
X-Gm-Gg: AZFdTZcQ7NBHoZRZTD2pkHjj+qaw+9OnN/vLLBbouUk/HnYZ5x9OqdxvdftMxhdq7hR
	7PUSYOdcmzp/r1nihZJ+ufzXK9aTACTaPjOighZMqwmjG2W9jiZPYDgZtDJqwOkcRR3KNPWzPeP
	agbF5VE+hGWAlYE4h/UN7MCVQNcWJK+ZDG8se8QS/oPhed2xaUcA2D5zgFDq8AYRfznKUe58CZd
	Du2rLdu3WyDqd3E0XGXWRf7QKWCBA4Lc2OxpFSOYz2sHsvFvqdV08OhTRxoRW0iQ7v4NoPZhYG6
	JUzJOAMrkwEvwxTPN6gYLFwEXgCYKZtc3n/rsio0nFQLKM0apAVDKAymZ2HUYa/ITX71xSJXyPp
	auqfXTzD6/zkYvtcIJGj2FMVzcWYyoikzYY9p71tu/nTIsClrRHXlzlDWkH+FrJnj7J9hg4AhPg
	VWlRtLrOJgHoQ5ZG/5bq4x+4HJeYjEzhNO7W5uXjuCeDmqE+PnPQeQ/AftiZ2JHu1PYQ92GGDAj
	SpdR8S8JR82Xj4en2kCunytJgvkYJO1++sA60EGkREo1TDdYPgT0/tIpv1AQUTE8mbY02tfvmVa
	ozQmHaXeKwsACUayv0pPc0JYb2Dzo+exDyh4IPh08CDQrFhTr0CmfDCNrm5iMNUw
X-Received: by 2002:a17:902:eccf:b0:2f0:25ea:8fa8 with SMTP id d9443c01a7336-2f03f176abamr169618335ad.19.1795567193320;
        Tue, 24 Nov 2026 16:39:53 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee848c1sm75603595ad.10.2026.11.24.16.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 16:39:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Nov 2026 16:39:52 -0800
Message-Id: <DN3VG4JCILOO.YN40XHHSWRPH@google.com>
Subject: Re: [PATCH v4 03/19] kho, memfd_luo: Reference struct kho_vmalloc
 via serialized pointer
From: "David Matlack" <dmatlack@google.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "Tarun Sahu"
 <tarunsahu@google.com>
Cc: "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike Rapoport"
 <rppt@kernel.org>, <robin.murphy@arm.com>, <maz@kernel.org>,
 <will@kernel.org>, "David Matlack" <dmatlack@google.com>, "Alexander Graf"
 <graf@amazon.com>, <seanjc@google.com>, <jgg@nvidia.com>,
 <loganodell@google.com>, <arnd@arndb.de>, <dwmw2@infradead.org>,
 <baolu.lu@linux.intel.com>, "Bjorn Helgaas" <bhelgaas@google.com>,
 <oupton@kernel.org>, <alex@shazbot.org>, <gle.com@google.com>,
 <pbonzini@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 <kevin.tian@intel.com>, <joro@8bytes.org>, <kvmarm@lists.linux.dev>,
 <linux-pci@vger.kernel.org>, <kexec@lists.infradead.org>,
 <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
 <linux-arm-kernel@lists.infradead.org>, <skhawaja@google.com>,
 <sagis@google.com>, <linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-4-tarunsahu@google.com>
 <2vxz4idb1i2w.fsf@kernel.org>
In-Reply-To: <2vxz4idb1i2w.fsf@kernel.org>
X-Stat-Signature: fx6h715edig1u8wxh38feuq9i67hwjao
X-Rspam-User:
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3F7841C000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1795567195-144676
X-HE-Meta: U2FsdGVkX1+RSM2tMKN3lS/a2xMyZzaMY2Xt1YhCRYExiFtwcRwUgA9FwKWjfAaDEJS6gnDUfzhU2UrtrRprvws5GH/wzLszNOlkAOks4IL4obcwH+eIK6zd45AonDWFcZxKWAiIh4bjlIyS31qg+Mq2XMXlKzFNlk7C7j/xJCXUllD8QitTMDywVp+vCqF4iuh67xelQVmsnV98qyQpUHlC8qv8M6JzdQIMB6MWL3HW+XGj98GMMgaRyLJFyQcZmobBah+Ug6pMVKjvem7zlDKt4BSSJX4L8Ws7bvNVUp5bHhTB4tTamkkCSBN9yqFT/ageCaZUjJ7PATUmU9zoEmhLsUIMKr21vtcGI5Cf5k4RWeeItgLCynqQEZ0UVoMiluFSn0nV1l8hCXovTzIs8/gTa2wyTAF04PwqvNLvUtCMp9pVBNR6BY7uFluePr5Awrqg4x4fCH9229cjS6fDUOEZGP4k2ckY9bdQy0FLkqeWlrSohj+cPeqBzye0vbXuQryKVId+iA7DpCYrLE9nemDzVEWp8Zh8ZuKYkSSMaObhpW7dttxEWU7ZSQic+gEDEQeUBBmQvfDwSLuDaDgn3Wm6tw4dzw9WA24U5KC9U4aRzG9jVfSDCG52bIZeswOkByedSj0o/IBTSpPKBWdGWI/VkusorPykDiZXWs3hUMYTmWFcEfJKxhMaKP0gcB7+UCciLMKI8YKV8VbC3TVWckPmriG8CdKwqkoGwZfTANAuh73rM2sJJs8A2sKiKv+r9I6R6KzZcGlgrU8Skuxzoru8K+wwjwg8UztY29OEOEZMC7m9vsDSkGYAPmMQYP1LTSNPutFLZBxRfSO4NsQO/TKbSp8Cm0HUbxzkGPq1sHWW/rXISQFx7Ng24iJ3Uqn8ShJXVtIwCWdrvBfhAkuz/VZ5d8o9IsG9h34i+Qt9YjmmCUJe6b34e0AdT49aOaFu5unzYz3DcoGRO+9JGXr
 F4ujoFDX
 e4M9JCg+lhLXLAcKumti7xd3rfLhUVDrWKWXnEm3+Q0HhP4aFIiVhjAh4v5DFtG93br6ee8yECi9/nBLT+aDPp7xBlL3bHIFoDUgsJoCHxCzMjbzepPcTx/TEDKwS46BaHZknvlZO6OQrFSOCEMwL6x3BK/WGRRQ5i5b7slIN5zRE0l+CqpCSvrYkKwQvfzEcLDxO+87VWbOgRyp2V7qxIO+SU9JEnfbgG+xaZwugbI6ctJXFUq71v4D8aBRI4DZzLWeumZZTfMZsSkBCeg0w0karhhBL2Rmu83r0VWghh0l0ftfrD2PS+7yWvu4ZCDaP6Mhn1HCVVeV8H7vJcQ/YUSyPL+AtmLAeRMsvAFkC7TcQBA3NfpDOah9dM2XyLZIhfUhXWdTNuCXrQCK9TrEd13vnSv/VfBcUB06DOjsiFBqxZhvMqjiJlbBm2HadcGxJrPJxxDK8xItzIpdntDIBzmqEFNO2XTbHtmGZ7i+3rZ34mf0Sedl5gQClrOXxaqK2A2JNCY8g30tgb1SKdfm5iCXCVlcaZgmCpeuDbXecpTZ/b/tnuOFAWk0h1qHcyKd48ifE/BgV4oz2tz6ATbhAVgr1uZbjEA/5kYx7XElciTxsmVFKMYM8ya/ozGFXDExDTTrm0buCqNV122PgiIZPhvry/fY186Z0M87Fk+s1wtjgM2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri Nov 20, 2026 at 10:19 AM PST, Pratyush Yadav wrote:
[...]

>> +static size_t memfd_luo_ser_size(void)
>> +{
>> +	return sizeof(struct memfd_luo_ser) + sizeof(struct kho_vmalloc);
>> +}
>> +
>> +static struct memfd_luo_ser *memfd_luo_ser_init(void *mem)
>> +{
>> +	struct kho_vmalloc *kho_vmalloc =3D mem + sizeof(struct memfd_luo_ser)=
;
>> +	struct memfd_luo_ser *ser =3D mem;
>> +
>> +	KHOSER_STORE_PTR(ser->folios, kho_vmalloc);
>> +	return ser;
>> +}
>> +
>
> Hmm, I am not a huge fan of this. This makes doing such allocations
> quite annoying, and I reckon we will be seeing a fair bit of them in
> many places.
>
> The key observation here is that most file handlers need to allocate a
> bunch of preserved memory, but they usually can free it all at once. So
> we can get away with a very simple allocator that hands out memory
> linearly.
>
> I have sketched out some code for this, take a look at the patch below.
> Note that it is only compile tested.
>
> Perhaps give it a try and see if it does the job better.

I agree the manual packing in memfd_luo_ser_init() isn't great, but I'm
not sure we need an arena. This seems like something KHO slab support
will solve properly, and since kho_alloc_preserve() already takes a
size, KHO slab can be dropped in underneath it later without changing
any callers.

Until then, maybe we should just allocate struct kho_vmalloc separately
with kho_alloc_preserve() and accept wasting a folio per object. For
memfd that's one extra page per preserved file.

