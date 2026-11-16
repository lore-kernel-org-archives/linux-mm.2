Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E883606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FFSUJOlg
Received: by kanga.kvack.org (Postfix)
	id B7C9D6B05B1; Mon, 16 Nov 2026 05:37:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E996B05B2; Mon, 16 Nov 2026 05:37:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F296B05B3; Mon, 16 Nov 2026 05:37:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79A1B6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:37:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E717B1C42C5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:37:05 +0000 (UTC)
X-FDA: 85440629610.18.C7E4A30
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 083FF40004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:37:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FFSUJOlg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794825423;
	b=u3EkANoSWUbCyVqiXRPktOl3KJckzwsBli6LJhNFbaApwovBY9/Jx572a+7TnkI3CI6W3F
	6/0zWoSulmV1uZH1PjAfuIvXK0BVJAjyaFdQtv9dkYctxNBNhYjzi6RkNagO7HxoFBRxXW
	MXsj5z49sxkKo1k8YacpTINqWpm3C3E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794825423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7rA6Xl71xYXKV83hCBQM26oVzIZlY/G9Jtv6N99/NM=;
	b=EOcwtEdE/Kwss+AzQssj577smenEPjyRp6slc+ETox9l1W9K+XiCYky9IAPfrovRoNuMib
	ewUkm3ImIm2kAlAAzs/sPLZOBmHRq6zmy6XKLLSwHDN6UZWKUqUI/Uw2Jv01Jd03r341gU
	HXP92Q9oXaHvVMZtFGNkJhRRXdjBDgE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FFSUJOlg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49d05d51553so17765955e9.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794825422; x=1795430222; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j7rA6Xl71xYXKV83hCBQM26oVzIZlY/G9Jtv6N99/NM=;
        b=FFSUJOlg7kKzV1LTpDEDWoxaGmPyP2Q3MLOyM1TPw+BwUHJXRj6oWLwgS14WJMKQvU
         KyoNHZQNtjraifnO9Jnb/jwOWIsjtKFT+kJ8HpBlABu8utiI7fIYRi359/zxao9mnxv8
         gCqxizwPGF9JE7auK4vtqqkG2vht0bANH+izmWkNUUW4a6h4VkoOB+IciPkF9AgiqQls
         Mqkg3tRKnVJ+8iK/o/EyKH8RIlz7gzQOPF9otsgUt5VDhQIb2ORINY0bw6ffL660ZQvF
         tJBR80SwTJ3Q7sH6MZTcnqPCW2AG9qfmXneW9YZjkpnDMOV+VXINZ5ToWmiiT1tfhlb8
         49tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794825422; x=1795430222;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j7rA6Xl71xYXKV83hCBQM26oVzIZlY/G9Jtv6N99/NM=;
        b=eS+iPaad4yY/Q5qB/PrupjTavDvLFjePC6HhxMED5tVCdWZM9WEzL4+5ceNGbGZE9O
         C7mNvoEz0UEDteaQwXOQ/15xt3BMoI1efsACOHPav1AYyCMbhnn1PhoHFe8o8WkzQsJf
         jKaR2i01l+4rXxSXsiVdqzzliT/3LFchaPQ67AD/KIhYPecPiYY+JdvKuipb6BWacFtI
         EZlUipQpF5lR8V2qWrXTrpa0vBnkQ+yMLxLaVS2dY6s1OPoF/PFcNcJKdvl1b+wddNJv
         M6fCryr3okfDSD4WHrWzjNDXOVjC/km1u6LNqMGs4MuLJGavSU3zLrKGGz5j75nyHn4T
         pgbA==
X-Gm-Message-State: APuU4Z94lOluZsAeRvx8uKe4zRs5PerSU+cr6eqGJIOg6V3GUAyoKxsM
	2MVNkElYaxLoRMAPesC2a7oHV3YNEt3IZjkY0ta1iU6aDHeHzx17VRwr
X-Gm-Gg: AYBFou2+vSbwfjEgPFKlD8QkxMofaYmCEbGKpmEh3zQ4sLGC1X7nNRxBTzy79/R+PLD
	ZcPvA/DEq3pbsHtQ+5O8VsenMMypdcDNu4BktA2w/5mYvueQYeWqT2eM94Aq4fMg4E65IUjYp+/
	5oJpJix40zUWIa95mr/Ra/PRWivbuR5KW38TUX9/zTJU5oteb6uUH4glxhplG5cyuNjoTf4yBUJ
	3PHbO51tcbC7nkrBqWJfMueVSw8sGHU9ooOk5+LpO8JPYFnV78Xs55+d+W7eKkvbSIq0NoQTrdW
	j1k5PsVHsSmTKEn/B9Z/NQFNw8VmSTsjf4/mL+A2FLGk55NKzD5+hXZi0NSOcsGvYw1l2Iuqcpu
	CfOzwmCWYIswK+0NlCBEqkXf7E60ci/DWCzk2GYqNZ+PPUQK+HTzdd97mZES/qOMycTUuXwUKmV
	KSeNFk07Te64sjQuk1Jx4H8FYEr3x9kJscOE721dqGA5NrLcQmfqyoAJxYGoQOXLTxTbSpSX6TX
	2WfHH8i8YyBMpc90GagO21/V5jtPKltALxrvRhBkZyBXciUZbybJEuMRl2SbTqcWqyvEQLGkVAZ
	ukXITtHB1CpMIgBC136Wq5SW
X-Received: by 2002:a05:600c:4e56:b0:4bb:7292:b871 with SMTP id 5b1f17b1804b1-4bb7292bf16mr53530855e9.14.1794825421700;
        Mon, 16 Nov 2026 02:37:01 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb62d5ec30sm294131895e9.15.2026.11.16.02.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 02:37:01 -0800 (PST)
Message-ID: <fea564eb-eafc-454a-a6ea-877d5285ef0d@gmail.com>
Date: Mon, 16 Nov 2026 11:36:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/memory: do not report OOM if insert_pfn() races a
 huge fault
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-2-537605643f6f@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-2-537605643f6f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 083FF40004
X-Rspamd-Server: rspam12
X-Stat-Signature: n49cy8tfxwe8d7ukjramhwmpw7uiydgy
X-Rspam-User:
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794825422-259293
X-HE-Meta: U2FsdGVkX19dgLjItALyjcZ+BtqOJSj849aUsycu5HgR+R2hSk7h+dNdi25McpmQcsXXRSMr36fNatV8s4XVIxfN+b5H9OdXPe4YuycUcoNS5cYO9pPsJaVsGLVYyuntu9K5jiuQbIor9AzBZrCGzR137L4aKZiVhtlLDggNjl7L+5a2E3ck1GVrk1VT6fXGOu6fkFzQAMf8r0CkkKoHbLI+fMWFFzwhGWbx4KYyXczQNdXmCKX8V21/LiJxitDsKjDbc5mS85DeS/3kGcn5ycVXwNFGGmbjiyCV3+AXaD6nv8FQogwX9VdmB/tUUROJlqolJOFrhEkJvS3kje4tT7dh07NM2R+iTJz0Ome/14WU2GKd9tqlZBIkl6m/bZnz6XMm3C3+bogiefWb7o07VAt/RmvC+L9jyhyL8eUpIBVs6C2iW5PtlAXo7uUWGAUDScId+ZY56VmN4BUfSMRBBI73kSKxFaJb+5vwBhcVI9E1bYJuwVsEwxyfxYYIru0Kr+DR3mEqe4Ac/tJnMduZgxs1r/mxbrl1VZyJ2m4XOc4/hmVOhHJtea0OdNSMS/UZpctHsWThNeI3kU2QW1av+E+kW9Ihzt5pMmGKqU0MRPOzoonF2GVkBYEJWydAmVW3NwM6DwE+EKcQ4XOyXGVze5kM42Ulk2uuvgmpZ2vvkAL0chSSfp59tsHJVZkGucfYHSpaj1mVbsT4q7I4qoLA5fzRAAauawVJLVG8q4sl6njdsI9Ha/MxJN1Mil02nQ2Vfu1xu+zCBuxn0OI8El6QqVUKFWq0v/HjjSBhhFd7HsPOLALkAs5GOCb14wr/bL0DPeIQgD7IbFdvynBQL6qDwrvorF/EvaWEHuW4aX8VM4HhMeObgZKiol2sHABgLuyn+q5SXI1LM9w0EBcr82CtCllfcoTGvfrpmCsTfyaeTBZLw9WAEYLxpUhLju3v6JgVNVWEY+/RyP+nrCU2bLe
 IRqxRmTB
 tFbfUwsye5ccpDVnppBEZdFqIHDaNrqbEz5nLRd6T5wJHDGcoLSnpcKGeRLHV4Kyx9OJiuyljwZnGvDbaRqOejJtPrLcfbadFTmfScCWrg1WpYC7n9ywBDnE/TUzG66A0h8JFVvpfNeAOpfWDUUQ3FKyQJAYVWcJmWyndVjNrgL1oTV1200oUCNKANbymMfGAJL/C2myXB3YRBZMpCHYt8Egyabbzsemf81pfzi9EO0V0rWOH4O68KizX4mP1Bsm2BNiypm3aNo/HGK/LvH9tgBm11e+CnhlFIO1NCwGCtvDEbr1PXMdkgoG6PbKlc/HPcWnK6V8UX9ej7OzI7drwYqNFK9riGSbVO9R6afNaEbtQqSel4wxzBJMokzeVPS3aEjHy3lWh3FxNBGT+HL6ZEA9dTVCPw03euPNcpEFzKWW+RF10t539xBozwqo5o3NxNVLFQUqQ3Qt30QLWAdCXGdRWCtTYonz6JSlylPmzOA54M83PcG97N23NS/c97yOkded/w7aDHkdGTKfpbuSKOUMoJeQOVuUc638L0v0Z8Ot/XtxH7aECbcJmr03ZJQPQOjVqAT08Zd6DnV4G8pCB0ZVErQ5wOluTsPvrurOtY6yR3mm2gtj1DC6372FsQdCYK4yC1o4AXClPg18xW5AMJHyOw0ZY1ZH0ZxWHoTH5EvDspukAPmPWiTIthFvmV3HR+CFN+8BkPJ3InHo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 9:58 PM, Lorenzo Stoakes (ARM) wrote:
> From: Eliav Farber <farbere@amazon.com>
> 
> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.
> 
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
> 
> This is not currently safely handled by insert_pfn(), however, which
> obtains its PTE entry via get_locked_pte(), and treats a NULL return value
> as an allocation failure, returning VM_FAULT_OOM.
> 
> The issue is that get_locked_pte() also returns NULL if the PMD entry is
> not a page table which can happen if a concurrent huge fault installs a
> huge PMD entry between __handle_mm_fault() observing the PMD entry to be
> empty and insert_pfn() being invoked.
> 
> This can result in VM_FAULT_OOM being reported incorrectly.
> 
> Address this by proactively checking whether a page table allocation
> actually failed, and returning VM_FAULT_NOPAGE if the NULL indicates that
> we were raced instead.
> 
> The same assumption is made in insert_page(), however only DAX implements
> ->huge_fault and can reach it, and it serialises faults of different orders
> with its own mapping entry lock, so it does not require a change.
> 
> Target the commit introducing the first driver able to do this.
> 
> Link: https://lore.kernel.org/all/20261112051440.16140-3-farbere@amazon.com/
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> [ ljs: rewrote commit message, trimmed comment ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

