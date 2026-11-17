Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D628D606A331
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FrpgX3Iy
Received: by kanga.kvack.org (Postfix)
	id E1CAF6B05B3; Tue, 17 Nov 2026 16:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4106B05B8; Tue, 17 Nov 2026 16:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE39E6B05B9; Tue, 17 Nov 2026 16:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98BA76B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:51:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 250BD1A0498
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:51:58 +0000 (UTC)
X-FDA: 85445959116.05.F1C57A6
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 46F4F1C0005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:51:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FrpgX3Iy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794952316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=od7whLjYp5CgaE7fiVH0EHWEg2I7Xd9uLKWSaqIJaMI=;
	b=GLnreYhEf9liJSayDSmLsmlhYj+C13wr0XB7lOz3Dybua4Qu0DZITeot1j99B2k/i1FwFN
	D+LToKYKP9c0L1/gzuzM77eh2Zqxro7MWFWuPdZdhQfXylDTck8kyGTDpZ0U3FEAqMntrd
	weLj1I+MPaxehKQw/TIjUvQMnuSaAZw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FrpgX3Iy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794952316;
	b=B6gIvusx9ca4bi60q3kfTRoL80a6Hf+ockpjf46aVvfNJtZZbHKrzB/dI0gRXrfSpvQTWK
	0BwJesOz1RDHoxmqIs5vdb8lfk5VDTF80lCRnoT18g5v+2S4QWHxKmeRdK8MT80WTOmVYm
	VNX4FsfKI/kxQB2WkcKolbJ58httaRM=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb55cda775so1076465e9.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794952315; x=1795557115; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=od7whLjYp5CgaE7fiVH0EHWEg2I7Xd9uLKWSaqIJaMI=;
        b=FrpgX3IycfBriXQ13ZfvFt/tVNeKR4FA9bQLxLYl7NPYkKJOV9AHZeOEwA9uA+Udb7
         uxBM+O7vB359loLoPUnWKvm/l9cYchdPZ0vnzbsRC3+vn6oWzRXOWvLHwvMeK+ZI4hZi
         gc8k2rEFY2rWaPEuQ1jJN8vkQgGwSB6O0CGLv4xjGvJcnBW4HokYSyh393+OAQv/R31h
         AhuqmDr3gdWX5NhjzJmBQbifpGuf52TtjmGnphXSqKVJPfpkQTFOepfA21evt6LPiIH4
         t/VQzOD1YiNMTUlymKbzMUhcB7bH0W5wpL4eC18RxviLl6G89JXK9L4s0PylRyETQCY9
         B0MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794952315; x=1795557115;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=od7whLjYp5CgaE7fiVH0EHWEg2I7Xd9uLKWSaqIJaMI=;
        b=xAjUzxTt5RXHYXwZuGXBL8hmMnTf/PT2BS5l5uqSOqbfU/Jtxl8t9a748gT894DOtK
         FMmJR3K5Tcv/cLzmAyzoN3vz/I9e773S9dQFyIukUBgGW2CBGgt7uzRTD8r1nJ7ML8Ou
         h0Y9t5ORwbzowkwH+VemHLejEXE2hAcQU6H50tb8CElYCW3pvQodephkLVMipZ0EnBMN
         7WnJTGz6OtmCfRunUeb1UDfJ1T19Gzw+eb4fagSWrvwNNPnn9Q6BPmo8yPvvKLXoE1AL
         tx63FQI450Mm+gsGYBF5J1mMZoq/qpFTq+yVkoyDoMqLubwkIBVa9gJzmcp4KFyPx6MU
         OXAw==
X-Gm-Message-State: APuU4Z94OFQmM9A0DEMsD8bvOMxqyCgXUT9WfQ2bidpoc4tDg+WBJuAt
	M/pdLcGfYothWbGP7OelRX+RPCIFdre96b/9AndGF3Tc5Fw1FUonviyt
X-Gm-Gg: AYBFou0F2OOR7R/DQ8HLbrPgQWuSyiu/EYGxEQF4P3q/eCIwZB7xdmK22aAAxZNIhFE
	/OodT/HlvTnXktPXMnKh6wbU6yPV/rZISURNzbUP83dupD0YTj+GiDbWSpJvvSUEq+qxPWZOAvl
	jd7nqsPizxUQypkKnqOzZGHNQcmXzcFQYBdVpYP3b3clZVWBpXrb6qC9I96kkf4DBztrB/olDvv
	mXQEXG5xVJ1NGrEenZsFFkAFOmnj0gGzzMg4a2u8cBxmWMMbbDtL5V8xTIK+Hs0To68glr+r1ii
	IkUradIjDcpFHfj+2aDxawPyE64RC/E8ZD6aCaGcnNzxuzgiQax+F9xiBFmNNWW0NvWkEZKwU6E
	UUPaVs/xbxaI5KrLQmqqwBnatxue0gJ8yLjxFaVHW/Re7dG0RvJXyUjK7NuZ6tuyRbazgMnSF+T
	DXdStK+EG8APA8osRjlQAHWKZiyU0YrLWY7Uio146Rx4PdOgGXfqko8UDp6rZ19v/x+H24XSrJK
	lttRsT8y1fi0J4+YjcIDZBqLkNMIYWjhgG4dtOEbHR3qozo8ArOGlv55wZOgVRXVPBc8SmMwOMt
	y2ZkUDtUqWQt6cHBJtVQ7hot
X-Received: by 2002:a05:600c:a54:b0:4bb:5fd1:92aa with SMTP id 5b1f17b1804b1-4bb7da30033mr11230145e9.15.1794952314685;
        Tue, 17 Nov 2026 13:51:54 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d256f64sm14627035e9.1.2026.11.17.13.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 13:51:54 -0800 (PST)
Message-ID: <817544cd-8b7e-4193-bd3a-c270284f6c8b@gmail.com>
Date: Tue, 17 Nov 2026 22:51:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm/memory: do not report OOM if insert_pfn() races
 a huge fault
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
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
 <20261117-huge-pfnmap-fault-races-v2-3-276007e73bcb@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-3-276007e73bcb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 46F4F1C0005
X-Stat-Signature: wifwfsfwutedhj488mow87gafsodx9bg
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794952316-484344
X-HE-Meta: U2FsdGVkX19SGNqxo+GLt1HpE82NPgUCFUFVmiEBieyPjsEKvbJNkCJj3sOvrMvxCfpqTOGrQheThel3q5D3IQs/GCLLXp0Fe05mS4S0hjkVgk5Ihwg0UXk32B8Em9T5xM+k+Irlu5WAlKKXy2VZ+aFFTernHVTfy5HfqBL6X9x2nsRGM6L7pWxdun/IFEGSelgsgWAv0altdj0/HuYRxXV+ZrZTsMl/4Me1BeLNZubnJugmNlB8vtix2xvmuSBfv6/vfe3xFSXIt5sfvH0+r6X9Su4JkkTF7GTpU4skVk7h7xdolhD1xabhjkLx21VTfc9T+hAYlnBv3OKMc8X6iTe7D0pjnKsfx/RvRlRB5M/y6CMMHtmt/L6aBaaEydmDx/bIY7no4t8lNmYr6QGhX+LvM4vv0TDb7thCFWBR/m33GtfB4i0OEHN2XfJoVAysN1lPngIIltv5o3OID0LgyH8SW2nPIZQXX+o1WLGM5YIeclpBkCwa+5cZXBt4NLaTFEjUXFD1U18ovrDLV4ek1pq2HovY23hfROjHexCvg4QxgC7/pVSWJX7CrPDQFe9qs+Xs5l6+rMXCsrO9E27o84gP5xJ6tkroajtiovpYiB2RQhn3egjjmf5CSiVLwvO+figE+YI7WDzpOvxqxmYJkEwCDjWm3u6LnxiJg2203GktSIHpM1QqaCyuZhiGjWEr9pk56m2x+FfsyQSoID69WHMvEyp05JswDMmo22Nzc1YCUExVMJBK4qyafBMz5FV2RlpERaT3q6K1tkiTfiNNoRVJIfHX32DlTsLZ4zfn3mVFbscmcNLECxuUAJz1au0+nfE2J6wjykIi/6gHYOXilzWuvY+iQFlULpjpsLu1ukZglO1ZdZ5FqQC9dCDHDx7maFqnrkjQXaKNs/Tu009Wbln58l2knc8i0hoV1AhVHTSfqFlRftKDavlQ6DJxU5sU96smJOrL4JzQex2il04
 GFW/+IOX
 xea6OLdBdmIZcGDDazFPgB0emWViO3oEQXYbyqEmxOdZ7gzZ+y/XtpG9yF4pmanP9L9W1wza0tPLORAmwkPWeLgqNpSUndz7lC8/eVuJvl456eLOMNZy/wI4PtqBLYikYZNZzxfITUwNJqgjbqUS/+XBFiCG89Ky0mU+fixgeLR/1WwkAzcGjm3KWbQlfFKmQI9Ju+HdMKnJ4TD5QebXlztYziLR/pZsYXitIUKpf/BASzqwWBGkMa5f4ghnQmOEo8xSqMjiHsxGMYVqCqk9VqDBt0e8e/VOyZRnWDqdpiu7gBw9i8JakMxFnV6xlOhWpnh1HSifJuXCrKqr963OxXGHAxOD3shz1MMaVBLlIYRwqCPXLx3Hu/GBP0aMEYs0YXQh0iH3hLWM4+XB1pOsPogGrbFwSz70n3vx5UMMpMQsqz8jJ6LgOpVjVWRL8tc8qKEUc6D3mlvrWe9Zger3lmOAiFOmObW+CgjkpQyZg/nac/W5kQFxCPRIu/sZXQsfIXiygx6KodllKsn6iv/LVp9Kz+K/J2mikBLeptj38KcMKOVxm1UBTcxUyAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 7:31 PM, Lorenzo Stoakes (ARM) wrote:
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
> Fix this by introducing and using __get_locked_pte() which returns -ENOMEM
> if a page table allocation fails or -EFAULT if raced.
> 
> This allows insert_pfn() to return VM_FAULT_OOM only when an allocation
> fails and VM_FAULT_NOPAGE otherwise so the fault is retried.
> 
> The same change is applied to insert_page(), which only impacts DAX (which
> has its own locking).
> 
> This means that insert_page() now propagates the returned error, so -EFAULT
> in the case of a race. It's not possible currently, but guards against that
> changing in future.
> 
> Similarly, update walk_to_pmd() to return -EFAULT if it encounters a huge
> PUD leaf.
> 
> Target the commit introducing the first driver able to do this.
> 
> Reported-by: Eliav Farber <farbere@amazon.com>
> Closes: https://lore.kernel.org/all/20261112051440.16140-3-farbere@amazon.com/
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

