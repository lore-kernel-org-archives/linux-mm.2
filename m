Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 383F2606A891
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=kvWkS63x
Received: by kanga.kvack.org (Postfix)
	id 1B9716B05B6; Sat, 14 Nov 2026 14:56:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1439B6B05B7; Sat, 14 Nov 2026 14:56:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032766B05B8; Sat, 14 Nov 2026 14:56:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C76776B05B6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:56:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FF6A1A0148
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:49 +0000 (UTC)
X-FDA: 85434782538.25.DED6AB1
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 69D2BA0002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=kvWkS63x;
	spf=pass (imf15.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2FvWA6CWZEDhvwtscmjEDIo0Dx+bIAbYiK0/cRgf1A=;
	b=3Gx+wcFVz/nqF+wyMpHSHtdDExEKvVmsikJtkGoZSiYzKC5IeS3j8OuOKNzDZDwwx0yjKh
	+4P7LNZuSBtwnHs7RQXWxHTEpeqBxNic35uCVKSnuHXt8yS+0r68NX6oXZ4pZflyNUIzvi
	BK6w9h0eOy8cnpDgrOAX+Qn/gP9PgW0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686207;
	b=MMMLLLytkqSqTNoeD+7DAC7Hp3cspSpXjKLsfvsEWUfsJI8d1qSxTINtkKWnUcJ4TEin4y
	U9A/NpCe8CpWluTl8ny08mp95+o2MYecQEs83NX9FestrpGIXHfTK2TCZMeNimHUHL5RbY
	xxzJv2T0mQ2JmlEd+lWjvfQwfb/xb6U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=kvWkS63x;
	spf=pass (imf15.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cdab9e9761cso1729737a12.2
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686206; x=1795291006; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p2FvWA6CWZEDhvwtscmjEDIo0Dx+bIAbYiK0/cRgf1A=;
        b=kvWkS63xYg03bE46FolBqh7Fo4+FZJdm16HziSAsbE7BubCYHDvor0M7TmwVmA7I6w
         a4tOFgmVku2LxPh1WC8ZmiQaw0Sb9lwFbL/3UXvAgdc8OAIpZet57NGOAe632R9JkfzU
         3zmSrgcGB+ERhxfYirBSo4a0isbsAFOtaBRPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686206; x=1795291006;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p2FvWA6CWZEDhvwtscmjEDIo0Dx+bIAbYiK0/cRgf1A=;
        b=uaexXwdDajvMginY5i6KOcyKV2bYrVFjEwEp4n/e+ElNCRiuAlNdTla8wndCnVSUCM
         9QLXZcALd5JTpDVehF5QzXDZUvosakr05X1bUgL55fyBaLA5UkAYP6AEOFLeZuq4LVOP
         XZ9rUN62M/kqvYyEnjHPnDsUQmcMNML8mExl6T8O1IqjMVzEmBO9ZyLgHDP6UR8uVQdf
         ORdqQpnp/Z2E668ha69gU2mwzL/1EVAEciwk8B7AYqATincH+N9T7Mmc/gG47d8tfpHt
         Wh9vB8SyNJAo5XANCbpNmB25JOxdIsXmNzwgpwo98wAivNj0mpcCC9mPNqMoiP8qDnlk
         NEpw==
X-Forwarded-Encrypted: i=1; AL+hErEHcRaPaJDb1junGz/OxjgVLLj0Qt4zHX5l7RKD5Nd60k6I2gRZdvh1QlprU2lfP/whCdWB1A61CA==@kvack.org
X-Gm-Message-State: APuU4Z9QyTmWkrbL4eVhHJCEvLXw5SfzBFmUPFa2/CpIlloyNVFPvs1m
	ufPULLktPAPvsoKY+tNGha4dgRGM/eNhoCzbvGB7ckV/QCgpkigSZRDZF3NmmoFcH6c=
X-Gm-Gg: AYBFou0eCIv3Yhn+0oatK48VUj0OObCviyfRtcMTm8/lDf9Km14y5caN9DiAD6gdps6
	l6ofbOUTjAfnjy6QF92GdCZt4Lztt+zb2EIWvsikak4aKRAo+I9SdlJs0Tx5MaCq60seQrmG7vc
	cGvuug/NDecQc5cOqhLkgAI9WaI8/bjc2B0EphF3wWCIjwTWo5gHG9FqNEHPMgJNchILjIdx1qz
	Cj5XQZXdLG48SCxchzwaT2BnIR5m3SrEM/g7vmSKQmHU3LeSqLDgDjlHaoolheHiuX0J8JxdCOi
	kxwpWfMer8XLMg5MDnfCGVR/HjlbWeHrXi2EmhChy7aRdCp6ru4u0ZR68OJJamOoh9Ym9VycJ3i
	bx2I1Na/jkDBJrzg+LxUCrn76p8128rpkk8NgX/Wg1GArqSu1H441Z8WpnbD0syJ9f8Uff5J2iQ
	W1FW3//jXfl6EJg3wcAEq+wtGfzsfcv3m4AEJP4brXOY99MYoGsddAeC1tqeW+/M8YdR6hM+Hqq
	05jO8PBzhKVshCuTcvzM2AmZFXZaGcvLEJ7U8jhFHTTaXhcvvCwTwy6u8LL1VQFWgq5by6QQx0A
	cAGrhul9e78qWQlxnuqcxsDQUGOKe6yaRy28ZKJ8mDx6OkCyzId9VmNfjPVoMBEgFO8GPVNMI14
	1OPvOKfMnHNSDogubky3kVTUdGjTbGWrhSZb96TWpYJNZBozXdJdgwleTcc7pUqjdmWR+4jHTLd
	5P94lQLfaahVyMA3S7+PXQyylOE5Wq2btomcEPhS1/ttvEJwyZM3J6Y3nv
X-Received: by 2002:a17:90b:2803:b0:3ab:be66:ddbe with SMTP id 98e67ed59e1d1-3b1b0ba1693mr6466266a91.28.1794686206120;
        Sat, 14 Nov 2026 11:56:46 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d27d26sm14613174a91.13.2026.11.14.11.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:56:45 -0800 (PST)
Date: Sat, 14 Nov 2026 11:56:43 -0800
From: Chris Down <chris@chrisdown.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
	=?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 04/13] mm/migrate_device: allocate THP deferred split
	heads
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-4-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-4-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115643.a6727abe20ff6cd1@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: kzps7kd8hooesmu14q4kepatgjbdg6nu
X-Rspamd-Queue-Id: 69D2BA0002
X-Rspam-User: 
X-HE-Tag: 1794686207-550641
X-HE-Meta: U2FsdGVkX19uaitlkHGmmlNdQYvflUVfMVAXqgYRAQMf1BsukUkDRUkwz3HDQFxK724zxG1I+WwPaDjS/sGvcdbCvT0zYbB24vhIQVMvAcBkpixVK+vMnC79DOzN/K9L4Eg3Urq8KDF9mxFqJQOcb5i6ECeIPf6+TRsxhEU0ijMnH8JAynPuXI548qWLdJ8PvwWlpZy5DnJp5nF2v+rUTLQ7pHykkdlikftbeBBXp1sJj5dFeQ8OuUi8MWWhLBqnXdN4jO3OuitLa5uTWe9Z0ySBh81y6Mzbb0r1nw3quLtiYKUWZBU8Xk8mZTvqpP3KiM2GlNAc1z4WVioMBXTKwwUxSbjwUvXeIQUOe9LsRKZw6yBd3iRXJutzYbYpphitSfCbYeKdIo3gQpOt/TWM4XkcS5sjUTvyOXDKkkWcxEbfwFJvDR6FnfVPlQcQkCgGXgL9vrVZlT+BBJDuF0n2SqtgPFzkJFA0TRcAfkPjl/nRnAKaUpLb9Q09pbcwAzJX13wzEwYK7otn2WXV+hsCUmD9qQF3S6VRaBSE4E0TpDjU/0DyPsHMODWmsa2bOkMnE/cL4EP7hZz5d6xModiMUMFW9pbviIb6/v408Jy+VvZO4WmcODdWGibZPiGgyiCmL8EnO9Tfve+N5qikzS+7C34rA8d8uk6KX7tZSO1V/0bM2ze/ym1EhCouBvE1ejiMPJUiQajNTaVvX0x1IhSCuBy51zW/369BOJrEGfQ6h4l0wITQga1NYQulFdAkdRU0A0+b9J2kwdWTxkJNrwSVA6kBjDgy82z69FZDtqDfvPMB7u5V7F1n7nKPBlr2OszUG5DVB7SKj5y4cqgHEVsQ0/FG3ECNn54Nc/tr85a2uKQw5nAJr846jfI2iEDcZ2+xJ9QJP0qgKABpjwOPrYha2BckHUxzrFWBOws4bQ62bW3zx8hxqUDbKeZkHXqO3mffxFVo9R0Sr6pvxRIRp8q
 mw6PKFXg
 01SGrmrHQq44J/InWkeWef0UyIMTir3yH2yD/KwiQmO1CRBuHDI+3h9ZHJXg9KSAv63mgUs0bgF926xs15qC4DsSXFXoH3mGJHJJjM8SHWnulET5KSCC11hwpINbFbyPOkBGigsqLywDAc+Lmp1DYhkntQ5cnrAqf53DOPmYG2BO9jqhZ5PSTXyYMSZaiySKDgHRJI5860qKmFL5fiJrB3MDswzeZatNUWK0wKAuMJvdsAGSP1vyaWPCWZe+vOJodekj/bn50/0OPBeRx5aZyiwZsf25riZAX5kAVgLfpmqnkXWhXyDLAnITZdJTi53Kk5V1xEQqtImC75HvhhxRkBKM17+DZ/gwkff3xfz9AhKTGsPZGJvHzmEm60ko0A6VT1b29zYC6fmj0iW92ZLblto0cFBJH7fFaQCRMV+W4ORq5Cc+l46draSwLsWIxm1WqxcMcuUjjndvcmMPn7zaZ8JVfhEuSwuxk0Mh7fFU6rYXhkbJ58Rmf6zYDS4SyZtslRqzR1cu7OV1rFUU8P14G6BmZO3BlBqO+YBOgKZ3tdzRnfYyYl0k2mOzV2RJi72sX0fSHY/BmxkUPnps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

Thanks! I've tested this by migrating into an empty PMD in a new memcg,
faulting the THP back and partially unmapping it, and the warning from
lock_list_lru_of_memcg() is gone.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris

