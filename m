Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BEF1606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Eg9bKqpf
Received: by kanga.kvack.org (Postfix)
	id 548C96B05B3; Wed,  4 Nov 2026 05:50:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9406B05B4; Wed,  4 Nov 2026 05:50:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2336B05B5; Wed,  4 Nov 2026 05:50:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 120D36B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:50:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D507A7F6A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:50:09 +0000 (UTC)
X-FDA: 85397116938.06.F2F4A6B
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 89DBAC0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:50:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Eg9bKqpf;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793789407;
	b=OwPpg41qlj/bfNg/nFXzj7IERLqriI5CYxTQQ10Xef/ffx48/S03PDezCHS1q+tXSjBaIP
	egkithTyaZLdXFGNDTsRkXE08QnRIUP5hVIPgO8U3PCXxHbgJbKqVl+DziMiYcA9ld7XmJ
	o1jPRWePX2vQUp1sONBy+kzuPOSFBXo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Eg9bKqpf;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793789407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w50lkh7YHn9snryw9lhNLJWggY8UYLvhDaLVNDzLe0c=;
	b=KldzLaRw9zKHPCAB+Rg2vpCNaGF0/jL/04CMnpXKeEuudsrgUjOB71fzoUPfrGn3plRvpi
	s6pdj0t4FZV95Yvr6WfUreSJ4dPxaZjstE/0rkkBokGJIEhILwURZOJPsXw+I8WmDPdi8/
	9WW7kH4iOivxzC3OTd6MqNz5Xe0ht24=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a5087a5348so4180795e9.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 02:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793789406; x=1794394206; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w50lkh7YHn9snryw9lhNLJWggY8UYLvhDaLVNDzLe0c=;
        b=Eg9bKqpfB72JQC4UZdH0kfQi9iCb7BRqZiDm/VPxXzVATaB6txeMPtUjMqvLKzigwu
         Mso92E+ldF1L/cuUzyrW4tCowZS6CEYXtNXqy89JfLxoQ/4MAJebLoQXmOttpOdbU8aU
         wm2F8BfdlD2LUfX8S4zQfgYsFToOd6p6PutdZrb11MlE/Axh801zETdgpDG8TmGrZvsT
         BAMVnr4L4NYSRWmxhbd+BcLv+NvPSPu681uC0yuY2+23M8GYU2x9CehvxmjI7sXtNZ8o
         VwrlrZ8P70SnNoE7PvRdeBbC191BNHJ0yYX327rzjJaOesOHlWiyENKjNlRiVv5uJ+9N
         neZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793789406; x=1794394206;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w50lkh7YHn9snryw9lhNLJWggY8UYLvhDaLVNDzLe0c=;
        b=e+EJxkmjML0PpzxMq/LGpjeJZbfJ1dp0x09BcCAjea/jr4/gEFAF1vUMDIAaOmRKo6
         et60ZV9dewYmKmU0vzUAy//MMr09AOkPcJFjE8mJ3J+Ed/1fmbeV8nb5OhRCNDjJ0C4s
         1k9yjtDnlniewvFx1e11J6BxDMYqnKOdGjxzj/lN+2xQE6eXPcDfLyyQv2qvLriY/qsS
         GzShkyHoQe0U5zAdINW4zYL0A2gXKd7Cb+VUlANDyMNgIrVFbk/ShrBTeO2E34nQzts7
         jqTLftD05QbYlonuAR1f5iLevedLRu4whyyYSqz/swlnTxqEAWoYMN4w1P7kihKlX+IU
         y9oA==
X-Forwarded-Encrypted: i=1; AKwUvBz2Q/TAYWO+Tt1b4kmhCke8w0AyiFC2cse4iy3fMytp+huWyZeGzEaipXTojvVdfiY554k0vhReow==@kvack.org
X-Gm-Message-State: APuU4Z92YLGtmca2DzJI+JCIBoJDZRTXHIoC2laVqK3QlHp4hEfT7/HP
	0hyGur+kTmdH1OBzN0v1chNpzGmwwXEyy4xuAP6h9ChPF6iN1emG1Fux
X-Gm-Gg: AYBFou0Ip092fJR2gClcXJ6VsnRyt4WD/IY+ccQIuCHWpmtawETyz/N2qXtko9ne4tP
	OzyG0pz96h7nJ3Kf5AVfgn4DoNY09quj7gjvwpx6m0aXz86E4AVavZeVQLXFSQLrWxBuQbS57sT
	dLi8JezN5/d2VQ2x0+jsX5nRV0NUvl2+1AAEvNMj8XRHlhETFt1Ku5K3aFLGEoKx0uIYertAP37
	tuZOghwTeMRQvbQ0YrHBJ9WptcRj9BT8v6cj3q78WlxoQSZgVnWsaCIgWA+4K/TZop/GBvw0FJI
	BvacMAeSt7QkkyhRNUOoSiqw51Zmy6lZY+BVV6pFNZJVH1NMuSVqHKSkbK9lfiAyw9MuMgYRyhQ
	nT9ALmWYJtUSAQz8TJNnJUemymB2HS8wa0Ox82tPJqicTrOnSBscDBXbHJyKanX5h5ix0iMRdGn
	voD7ojiL4qjvZOgiZ63iNAVrdRLUC7jY9PDXJS4w3DgwauKchEjJa4JzcKmv5OntdtbjBpsZFA3
	ujH6vCv8djHDOcnrWBpMB879bF+vl4hs31PrMYFIes+/g2Gt2yxsPHqKktHvtnLDhw7m6PKnzql
	zMTD7LQJH/Y5kafJmYPr8tZdlLLEszE/7VjPOgacUjyJ
X-Received: by 2002:a05:600c:1909:b0:4a5:26b8:4507 with SMTP id 5b1f17b1804b1-4ac18b7dff9mr356197145e9.21.1793789405877;
        Wed, 04 Nov 2026 02:50:05 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a555e59dsm145066805e9.0.2026.11.04.02.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 02:50:04 -0800 (PST)
Message-ID: <70686061-787c-4c99-ba5b-ff982c8cc2ad@gmail.com>
Date: Wed, 4 Nov 2026 11:50:02 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] memblock: keep reserve_mem regions out of KHO
 bootmem
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>,
 Tony Luck <tony.luck@intel.com>, "Guilherme G. Piccoli"
 <gpiccoli@igalia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org
References: <20261021211058.83483-1-azpijr@gmail.com>
 <2vxzqzhhg8l3.fsf@kernel.org>
 <32dd1f28-db55-4674-99bc-74d9d3ab25db@gmail.com>
Content-Language: en-US
In-Reply-To: <32dd1f28-db55-4674-99bc-74d9d3ab25db@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ee4tbpsr6mtpcea5irrzpexc984ak66r
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 89DBAC0004
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793789407-453540
X-HE-Meta: U2FsdGVkX1/5ws5/OTHddTCQ0JylbvkXeOP8h0484FMrPaobsZEx1b/zJ7P7WcFIt3e5/OcunItK0X6Wg2/UnmpJ8Zj6GOCGb0ax/gIeu0bWlrnWn91ehCpSS1AQFrTJA86PAogGJFX8aAmNR3hQn1H1GfJbX3kGvDaPpclG1IM0x8VPu7/M8qbDqSABKunAof6kFi7P0miWNPjvIObMGfTGjyGtdKibjLTQ3DWz2WikpFVbxkDd9q5wTBcbmhv0hSkx4TYoPpKLgJy2II9KzXL4r6ga16KvOMAAav7Tm7wbeIuK2jcs6n41rKkPFU++YCEPaiQep88tcQz3+YEyPbowczTa5CoponcTG/jXVDlK9eJ9/4S2oNsSJgZ7fpc0xUMhKgr81zzFYOwSeWkU6GUbCO8u1cfwi4gngaKpYukgUcp2rlVj22mHTiNZz4SmGtIGaYaDZKrGm4iMokvezTMPqbG2n3eh+pgQjhCm6w+MSRmEmH8/ufKY3PHAs5sA3UJfbMhIixNMT4pHYYHjEB1lRnR7Ap71YIKBtsUljtUBngExGuxrlcjaedxdOZN+kwJBoPgD58W/naxeRhpsPm+S5uXr5ZjmiDS1WmAvptr8u/dJRoZDU9+t4PQPyzJFGYo5E6cUTMJuu2o4hOgFutWdf0eXy5nelDL4Bqmh7XmKzQv+2o6JZ0zxIoTpw276425qF20binVmkhVcYlAZZWAqrK9HhQQ59MSgVycPTqdBXSRzDUYq97oNoEpFOVKsS3RbGiBl7B7zbs5lN5+r06JrnY4Apai0pl7eDxK5zbtIcvv/odan8Yge/uMWTUwEZFzWZtOSP7xNaQEjIQGeEPbHKtOXWo4YBwf3qeHAnKS6jcW4MMmyQM4nBSAAct2Bb/NOx4W5cocREf5adAtc3GIKdPoBY8dIUK9lffP5j99PN0N6xwlfKqnviEsZLWwdhQymYacTxZhemY9r6hl
 UuSTIqCs
 IfG56gFEI+aDNxri0llAn49k9jpOo1E55NjQrszxXvensuyWzSIr0H5/Kd3pqcLb/RbuusX5eW5hnNX+PyMDj3EaIq9iRWhi/Q1RdRQ54FrT68uPDODUFkqevsjGo/5nLuWRdxQUK82oN1FIGVNrtva/u4ukcqw0K7+3COGrTgwwf8Feedt99KOvlseYPvfYNYV9On+cRxMJBJ10FPQIPXKnmedNLGgieNavNMUrGbLzD8zR0Nchv5Gg9Q0kcH+lmbLQRckXUD2HxzW1Gi4sD2mekZykxooX1tIMr0BvAFx98A6mEIaUAQBA8rB4wFmZvDw93SPyF1lBELjPTO/+ecqaQbFTRP7XL7TdazgcJpGS9WetLI+t2ONQKHcxFi/+/9x2mgfA/4rQC+AxGtzmb5I1GxlM4cbr8f1/DhuMi4izoJnSV7RvM9UX9O1742p/cvsGeyg6YDWx3+wSuaRuNPbitDylvRiMLRmv9Q92B5cDjQclH/EkNAd6Zmw4/zAbclsvI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/22/26 10:16 PM, Jose A. Perez de Azpillaga wrote:
> On 10/22/26 3:37 PM, Pratyush Yadav wrote:
>> On Wed, Oct 21 2026, Jose A. Perez de Azpillaga wrote:
>>
>>> On a KHO boot, a reserve_mem= region that can't be revived (new name,
>>> size or alignment) can be allocated from KHO bootmem, which the next
>>> kernel boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG preserving it
>>> fails; without it, the next kernel's memmap ends up on top of it.
>> What's your use-case? Why are you adding new reserve_mem regions after
>> cold boot? I'd rather avoid making purely theoretical fixes.
> 
> I don't have one, I found it through the TODO. a different reserve_mem=
> in the cmdline passed to kexec is enough to hit it.
> 
> if it isn't meant to work across a live update, would you rather have
> reserve_mem() fail on KHO boot when it can't revive the region?
> 

ping, I can send a v2 either way.

-- 
cheers,
jose a. p-a

