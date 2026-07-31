Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B2EC5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 14:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82EFF6B0088; Fri, 31 Jul 2026 10:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80BA36B0095; Fri, 31 Jul 2026 10:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F7CC6B0096; Fri, 31 Jul 2026 10:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41D7F6B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:21:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C624D80431
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:21:33 +0000 (UTC)
X-FDA: 85049284866.24.C5416C7
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id A981D160007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:21:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YE5yomCF;
	spf=pass (imf08.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785507691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BqwAfgX6QeSnV97D/RnhlgmbHEZyyQJlqoEom+VcTo=;
	b=bKhAR4J+fmtjR7Jq/s8XihmmxHFriEux1743ZilUP5G7hQ+pjPYEN5F7JVj8tpQVIjBjSV
	vJnvjmkvjljFXDyzCZseMpgqGoI1qReJZxzvHcserHQIDZhMsKuOAPP84bxlI2KCwurwoi
	Vw3mmomTbr0Y28lWtHBl0LR7dtX6r6M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785507691;
	b=zohWwR4d8//4ACaUtZFPwRlG5A9XtTu7bndh8gOa0IauNLfEljrQKAsDucyCq3mAyYBkPp
	wc75nBvcwzSfZWiee+ejuzCQ7Neips0C/mrB1wgsbbbgSdvdSnNMgiyUQFLNsl1QpNBosw
	O1N/yfMFrwYfrZkBJD1QLrbRpPP9EBM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YE5yomCF;
	spf=pass (imf08.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1c4db7ca93so135039266b.2
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785507690; x=1786112490; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3BqwAfgX6QeSnV97D/RnhlgmbHEZyyQJlqoEom+VcTo=;
        b=YE5yomCFBikRyqDst6hnOLj09YmQIRBuKjPJJR9EVen9PSMiG4H+PSoAE2AZ3mqIK2
         EMWXketmW7uBu8ACNOoDoviE0Yz+fkgtLcipq1S5L19BeMskhHw7kxE+iN8yrRj9L9XH
         OJNXbd63+JQ8GLtufJ5aqxpl6y5VBUPXF1jX8OowK7pCK5lSiT+wrpaKGSJrtsH1dWzL
         0Cow1Dn74rO370bYfqDWUsSpg//x606ovOAJNLZvSJ07dTePlNLUhl5hj0Znb/Ye9U7f
         BmxT8Vm3v/0zN+Bom/gucXMn+p54a6AU9f1TamMaQI69y+ZicX3EDJywC9A88f96KIrx
         b8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785507690; x=1786112490;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3BqwAfgX6QeSnV97D/RnhlgmbHEZyyQJlqoEom+VcTo=;
        b=HmST4D5AJDHutk5hM1pdl/lDPbBlAKBld8O2fu5OPlh2S0in+knGPL79ZMD+JwFQ8D
         4zscf4sz0eC8gGPMxMBqwNErQwBW4U7umVojaDRRV9txGpI/qyRt6mBgqovqKneJlW6R
         wUBT3KzFbhkOSxW/5S5c8DCS8RorymySiriz9d/ffaHd8/9b78Vv5fC8a164wiGco2zx
         dSabkEUEqm21vksCG46j375sgAjhZrzbi38RJJMISVCa1EwFT8WHkZSJ0XuAlkW/t7Gi
         V4bu7vBaTh9OZCNUFt0mwrMlXRfEJt0lMeMUQDqrONMHuJM4NuTB6uMU3awh9LnIQfWa
         TVLg==
X-Forwarded-Encrypted: i=1; AHgh+Rry3pBiaYUo2kJs3c+leHR385pPLhIQkv3+/xsXCSCryFy18AimamqrEq/IRpBS2cw4MMyML8DC8g==@kvack.org
X-Gm-Message-State: AOJu0YzyZXkKnDo+KVarZHQDEkA/hmOSqrp8Q32a7g3HHyY7r0jCb7Pg
	pYoim6etacQ51qYPbXIqu9cyQ2D39ubRFEBL2z2I51LKWtJHA9ZV5O8OR2CQUw8hTs0=
X-Gm-Gg: AR+sD135rQqnmlYJrdngPFPfVPngi7/8WB9TiuRLAYcxtb1gvplrS/hD29bENE+LJvT
	aDiBQ44ZZNWiOlXhVyyK0zjgsHlt9FUBjjc3aWaTf+jyxTUqprz1mhCFEdy55G4Yg3rUONAUXKW
	eGWxcCIMlmQ+Msw8U5RnXirG8cIqTu+wlGZ1ZttwEqe38kHIF51SSt4JWm71N0TzbUru8rGeB/P
	GX/+YjttBShpUv9LMn+WnFs5EF4VQc1SW3buIOCJzrInZyOUYH769Kj6uw5aN8YbQAbVvuhdv8g
	ZKb8ori3XF19EUfdGn+sP7uQN34ef4nF9JbK0kmnPqpHHBH4/0G4aun29znIgo/jigQ4whcbyMc
	fAXqGzoO9+oJbqjP2z+2umP3p/jvXGuCC2eK7wHloCDnIYfJsUFGoaveKZuK7cKNAcpIX+vLldR
	0+OzODG5E9umMaQ2fdOVZumKvVZXNBsb7CNFYN/kkUwI6L1KH2hTH3IC41ZTGisXY8uPNa7okf1
	9pM/CrisEIWWbNanvRmHjd3GQ==
X-Received: by 2002:a17:907:944d:b0:c15:ce72:9352 with SMTP id a640c23a62f3a-c1fd21c33c4mr165122166b.33.1785507690113;
        Fri, 31 Jul 2026 07:21:30 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:fc6c:f9a2:4a0a:6354? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd3c90739sm162999266b.14.2026.07.31.07.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 07:21:29 -0700 (PDT)
Message-ID: <b5d285a0-1e72-443e-aad0-dcac32d00d01@suse.com>
Date: Fri, 31 Jul 2026 16:21:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] params: fix charp corruption on allocation failure
To: Jiacheng Yu <yujiacheng3@huawei.com>
Cc: samitolvanen@google.com, rusty@rustcorp.com.au, hannes@cmpxchg.org,
 yosry@kernel.org, nphamcs@gmail.com, liuyongqiang13@huawei.com,
 linux-modules@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <ff0b7cdd-8fa7-4cb8-9e21-6a7204809766@suse.com>
 <20260729123243.790023-1-yujiacheng3@huawei.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260729123243.790023-1-yujiacheng3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A981D160007
X-Stat-Signature: 5zeoswzryq6teex7bzyjq3qacu394zfi
X-Rspam-User: 
X-HE-Tag: 1785507691-821305
X-HE-Meta: U2FsdGVkX1+F4gXi/oLlpJ1zuANPiORPHG9uGHe8qOa70KckOoEi2cTQUEzKQO9gVOFTR+SDENBhGAfxULIhPxSRulTgkTciHC06TyG22XF8qAHwTHoL4foSG9wJjzQuDKCDuNagKCw/SIxE1wPpMHQ6OH2TftNprvkKezK8w8IxsdUVI5YmiE9Yk43fv2GcSVygu7MFsqGHoNxZm4OgsK6a3iV3eK0+M9e0rpqVhPNbuwZrlNGU7OlgdIO+eYQTBItDc6Zw1Rdh0iuniGn4R4r9sE6OwvT2ORwIMg1iySVwW+JX4wCL+qcYqyQ2HwiTXsZWHpldNBsnpXP6leKQu1iwxtJKGLD3LEPP7JjLW2b8MGAxDZMR0ruPhH32EEcN/sihFpJOi7vtU9onj4ja01Po4S+QICh1Kd9iMneF8h12EvSwQgqAdb42yjh1VYrVZqjdvwDqUHXJ19w0RZJMfQhYDrotQptMjyGMNOfmpVjYOkPFRQLVu0IKDrPjGhSzVqIjfONuuf9776wkfuNomH2GPgu77ZZ3wQ0UkI8yad5TPp02sLmAtI7iPxX1Si+u+GGrbpp52y/O6dsd5xqI5kLEYaQQDdF3gInsftXjKtXfSYNCMIepVf99bwDoSEUD4iR1dvMnTxhb+Xiw2KOUWNoe3mJopPJMrgiO/ZgfUEEf5urJyJNufNVg36f/dxpq6+J/tPXY5mgklo4tsyvE0bZDDOTkeEw1tFhyRypfT2kLB8a1jtOrVf2ek6dEp06XsJqzrwRUl+1/m9nh12q7QTJYdzqeVdzmXw0c/ST00AegjfEzL9nbKcvip3Q4xsl0Xxyxn97KJyw/U06LaZBVZgfG43THqrYR0e9q4Va5cNrefsLVEQ/eOI7Slv3eSablP4/STLveBbMw3sZp0JxCPFYyvfboPSLnu5wWQXcTjMhlGIygb9JLbfb9HLPObG6zSaJSqg2HfusTGaZnXbl
 5Fwy08uy
 vcOfD7UPZNIJP7Q46eN3geG4sF6+2aeIlyICt7Yp9uGQzS8PEO7A9gvFL0KaPZr+jsal7lgcXECX3u0mKWV+RDJl7UUR1osH0yFpXaXsYNxax2KgfbObPJk9WHkgxgFHw45ZOWFUPtNkaQTPPNFEqrUQFEqmL20X76Q7l3jTUMycqHeUcwg0MSyGaESJIGbTEaqqH/kSb+WSR/ndj3iFY0KXi2zFDG8Q6qL1qAoK/z12y1GoHEsQDIxOmdhyUis05/bM5f3r2fWAugTT/fLDih/bkYjrZcruM1bpkzFvJmDQSnxLwCzdYZoQTPWJz8JUx0mTYgbxuYuAC4sjcfvt5s2PBjP3SBVCMQcGOZCHN6V7WLrBJIrEPWwADrgkOR2g5mCedpAkOHL98I+ykZI9w+gIm3RIvnLolhzMTQSQnyy0kUy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 2:32 PM, Jiacheng Yu wrote:
> param_set_charp() stores charp parameters in allocated memory after slab is
> available, and releases the previous value when the parameter is updated.
> 
> The previous value is released before the replacement allocation succeeds.
> If kmalloc_parameter() fails, the setter returns -ENOMEM with the parameter
> left as NULL.
> 
> Failing zswap's compressor update before zswap is initialized can later
> trigger:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:strcmp+0x10/0x30
>   Call Trace:
>     zswap_setup+0x3b1/0x490
>     zswap_enabled_param_set+0x5b/0xa0
>     param_attr_store+0x93/0xe0
>     module_attr_store+0x1c/0x30
>     kernfs_fop_write_iter+0x116/0x1f0
> 
> Allocate and copy the replacement first, then replace the parameter value
> only after allocation succeeds.
> 
> Fixes: e180a6b7759a ("param: fix charp parameters set via sysfs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>

Looks ok to me.

Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>

I'll give others more time to comment. If there are no further concerns,
I plan to take this on modules-fixes.

-- 
Thanks,
Petr

