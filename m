Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5057606A331
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=kw4YaZaM
Received: by kanga.kvack.org (Postfix)
	id D60C26B05B1; Sun,  8 Nov 2026 10:24:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB1B6B05B2; Sun,  8 Nov 2026 10:24:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAFBF6B05B4; Sun,  8 Nov 2026 10:24:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 862E86B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 10:24:25 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0227F1C3CA0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:24:24 +0000 (UTC)
X-FDA: 85412323290.18.6F3C863
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id 136F02000A
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:24:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kw4YaZaM;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794151463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wks6IuPqWWMlFcHqYGHAoryyAYjkkjwfVtcF5N3uln4=;
	b=47z+THMS3KFuqjeSZ+AntizpAArtAU+aQbqMKzyVMSIAgCAn9Wa0WEbaqt1YsTt5yf7sEM
	RvykUk8vd70nPWwXPBX+NfzTgJjN8QCvu17+AyekcF1ZG49aYVA60LT1yZ3Gu22QDjizJA
	pWkZ5x3QpUuubZOpkP20YjSchRCTj/Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kw4YaZaM;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794151463;
	b=BhhYo5rfy+uqZbxOnQqg23vfrwdFRczT4DN1fmNoKBosch4CiR+wiF7lwh4IgQh9yUpqtK
	kfVUk9RihgYUMdfevXLz1wccahblC1Rrp72fEVTblZOcTIqqc1Z2etZbiNWtgaVS50VZNy
	ry1UeyUHn//rOsVS7xbGfSNemcnryzM=
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-99c042cee7dso50669241.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 07:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794151462; x=1794756262; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wks6IuPqWWMlFcHqYGHAoryyAYjkkjwfVtcF5N3uln4=;
        b=kw4YaZaMPo7gf7GwFHo60i0StiUH32uJ1gGeIUiyWlVnAHDx94QvLWUoJ6UNQFwtG8
         keIrtf15qYeCpxZWId19qOYLM6CZejMvx12Pr82qiSdo5ouBxz/HVq31+JjFk9K6iP/3
         +5uH3CKAwOxHkOIW2Xs8OUWCH60Er8sSMxtImiqRHpUA6Yx6YzddVNdWNYs27d65K2w0
         wpBC+Or01YAIbI3zGFYtxeZ3AjlJR03EeKVooJ3cXNeaqPb1ojDJxUF1JAKqhfBlikdC
         EblMfABE5hhmgtwa/F89I+ivuiOUYDgeb/BlLegzOcEXPYDaMbNdwrOeMZeXt8j3jabJ
         UChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794151462; x=1794756262;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wks6IuPqWWMlFcHqYGHAoryyAYjkkjwfVtcF5N3uln4=;
        b=b4GNSaRmDdtpNj9sw8uAGGxji4eM+J5L2DRi+sdfXQaybS/xPSo/RSg9qxwKkgxYF5
         CcUkFR1CgrnwPEzKamS9DBuA6sl4ZvrO8vE6qLOWkhFA55Vkp0HlTdms/63upUCBLnxC
         yLasu63a5SGvRfbX5JzbDkBb+Kjw9utd+p6TQUGDNGOdcmue3flPI4yO853vQJrC7y4B
         TV5MKv0ynWssiaCxpFriy8n6xHWeOvN4PhPrGQUNjzSv2DJAyRwi500CAet+Um+4PBu2
         btE6c70qpL+z0AVyPveAiDXSE7iuowpRxRETFUV+879cfN8QIfVjGRTuesYy0kW+6nbQ
         lvTA==
X-Forwarded-Encrypted: i=1; AL+hErHxRPktyihmjf/wzLcBJbz+Y7Ostqy0VBHuBSMjQQJPP3Ta+oewiqBYAHw5UZPkjas3Au4m8pIoeg==@kvack.org
X-Gm-Message-State: APuU4Z9hXxdxhUmWHkZobr6tNmQZYQifyKWm8YktZrBNlDoo79qqxmVh
	oC8zkids4/CPm7dKop28bISB+BJw1qxsI2DHmy95ZfxCPRQAbbuwTQYLW+obw/7ctnE=
X-Gm-Gg: AYBFou0eYccL0yZD1vh/ZwHY7AhN0hAXnUgutDdN+Sv+M446OYzyM5DWyhIQd0TMeHV
	dszF61zMXYfEdnZDcdGDJ1SbZ2gjFoArpn8DxXIhRDmJP+sR+oz/bQeEgvi+GcDp6BMd412VWKd
	7Hp3fLOaGTLRskHu6dXFOnyP+9TXd6b+nlLFuP89Mcv6C5xDoIAVjhyP8d5YhOeBDuNEdp2MEEA
	6lBxh12ru347y+CG8RwPbesDgqIqGkmQgJYgrbl+X8DNdLXeIAaDG5YxIzKctuE42lGCp/FNRWc
	Y3w0oB59YJsFwqpJMHnPpnEnpojCRCIPeqLWX0h7zi4/x/2zBLWccTtTQhbdjOAzjfXWjN/Ff7/
	U27DZULcKOzCTHrNCrepmFg0bdCIxlM0PG9GmRSYEX9H717a2QyaxevPIWGUFToMaDWvwNX9LSm
	vMlPLP+dC7SnPIUmz6WCIVi0C5eLBMN0AY+mJMiHSjzDz8QVvhifipKxfZGNhe7ObNy63trG+fI
	WdAN2XtMoBCixWZGasEwsjs0HhRKSQhcAl9tgMiGguPwKYnYjK0exrnlb+omaFBjzMqcHPsMJ2r
	1QLPCnB+Szhe9ECm6nLwADFRn4PmrGFNLgnZvnxPHBK8kmBEMJArBcz2DyeHRQ1dYJ+otcVHviM
	fhzhiYZf84Mt3XEKSk8RbZr5P2EsnIA+G3KUByEpbCSwe56ka
X-Received: by 2002:a05:6102:d92:b0:7ad:3ad3:997a with SMTP id ada2fe7eead31-7d2daa685bbmr485125137.5.1794151462168;
        Sun, 08 Nov 2026 07:24:22 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ece60c1adfsm2166205e0c.8.2026.11.08.07.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 07:24:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 3/4] selftests: kho: Add riscv support
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr, rppt@kernel.org, 
 pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com, 
 shuah@kernel.org, guoren@kernel.org, linux-riscv@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20261106071459.2003-4-cp0613@linux.alibaba.com>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com>
 <20261106071459.2003-4-cp0613@linux.alibaba.com>
Date: Sun, 08 Nov 2026 10:24:13 -0500
Message-Id: <179415145358.358073.2579925146371313024.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=279;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=2foYgeRjtLhgriBAFewI3QB5zsYy+0XWNuIAF3mfsnE=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq8JQhKpBPG9CWddYheCPGKD+kNOAaT7Q0REO8/
 X0Xg5z+ESOJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavCUIQAKCRC7dyhM23N6
 3is6D/0UINh3QpPKiI0oOOWcH4They0T6KUWUtHH8paLMyiZTEZkaScs0phm5xLc845Ic9LxgmV
 Ob9G+SV8Wxahy4a/rO74Z83XKMVJDWYIpisVHoHivOtAWR+j/G79uLhwjA8WzmN5yO47Bk2nvkh
 ZzBpJEvC9rwTiftW3gZFajEGLRiM49GUVyVv//8qqXJ9Ikppz4DVWRb5Ym4oX6AGzPcIAbONe1A
 nh4nvYGHDQ8lBVPB66a6NO3U6WyIEfh6uZgSQ/++97wJ9wqMTtCfxkBkGLmKL0Yk1AOYpy90QwL
 CDTFSiHMVtve/xrQqdf0EWmvioVf5R+GdmTUyZYuD7pGWDiWkeuLrx8Fp9X79izbp51wQNuYxdM
 JdUKLm2Yg50CclKLaZ1Kfbx5gj3v9DkMLC70EqXxhq5F043Wk9G+Eja6C5cARA3buxzkWeBKNcT
 Ucgnb2XSQM/ctZe6Hg7U78wNzRetTB3KrvVsXeS8Bs4gsKjqptzAokRR3Ta5gTl3eFhb78CfB+0
 0xjt0yhEuEToGjrrg9yY6+cQe1olAah0ZoAIy3V59Ld0EoWxxy3a6V1KwMfNYvm1seTYH704eJi
 iPUZenreJsXOKLLBV3GO4GQh7ruky0RLLEMmdisjXOsYgfKc8xta8jxJJBAUKw1MxbYd41s0ZpX
 dEAw+5VN3pA4i9Q==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 136F02000A
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ndzcedbgqgcgudgg1sq58wi79r33oon8
X-HE-Tag: 1794151462-288316
X-HE-Meta: U2FsdGVkX18OpIrmMJtFIVTYblLu08SrU+y/skDrDH1YECRdasYIHGF9MF8HoEuTiuRnK0DbUBDyHtRq8+o4W1NjKuF5d8i80tiTYku/iy/OkdrO6+wuSZfe600m9rX8IEeCr+nEDwHo7eN9BqpB5Zg9mlWHQU8KnWoLKatHLAKDokgJ9TqNUi6TWAhiHTcZOSD8GTYkObHHCgIArIZ1wcpqiUY4uScqN8Yw/T58OBmMqGGZciHUYBcQywwRp9AXWkclWx7jdVSJ5N+zSwKNiKu7tf4arXqrmsbDQsY2tzIOeeIhRgGRmY9STtGcCVU1zX4dBKAWwnhF7Uw0AlKfCWqQEbGtw4x6d9XKEh9nZna3G+5KSDNqIVOscT2Zocd1BXKXemb2u0jxpRMfOs/r4TUHIpX6lW8cZ3t5hIPvja2rdzJxAu6g6liZEdgiXzbqsbRoCArVnWJUjeAv/nowr0iJfxla3adETpFeUvttznXhyhVybLXpb3gcWBx495P1/NdUeT1cxSZhbT0ghLYOnHq7aX7P49zxH4ASulhPEOV2t/KewG4q0NfQmP8FWXCrzhPbIkdBbK0MMYI0dZjDpqlHutj+HlKocFAa0WiRBNPltCL/skBE9ZtEBp1D3cDZhYZSdpLuslqHh7R2HBgwG5lKqTdpBQSOfMmDO8xn48dkY/91UbUgIKG6wsUW7wCqxtpDYv4G52qw2iTuVEC+EKW7RtzxO/IJ+WNYHkgnEhVY0esxBfAfnIG+CVlaNY3DL54dSXLS3P3Uz6faab2RV0SM6OOiRHo8VLu9hLuCyeGMTKGd+2XnhplexClGEx8J/fT1H6rXS7/0KaOOxE1dEBRDzC15TqSICPZExsKWEAW3GCrFuGQyZLAknJ7EdM+trZg4yQIFe0/UFY3+jnokV5Wc3nz51oIKUYh92YKVxUGjhjMHJ30+cxbtT6m5HCYBAEzGJT3P/QwvVw0qd1i
 9adgqOCC
 dE5WYa2CgeY7J1CJhMBuBrEOL3A+ydRFSj02pZejJIkyEvfiw096DcDvwq/YTIlQNcNe2I0nb7iCTUNQdF+y37pVO9+wIdNzEPr83dRxYxAEvnE23CERDLjKy7Ht6aJbhp2FpgdeTAphUa85WC3jK2E1f7SmaHwDmSRAxqh0cxHGyqet0ZSXP04+ofDqzLTMfQ3FK5gdyAJMitre4s/cHOeGJ95nZtL3lvv8obArQLDUlYTrx7GgYYtLaY6qH47acEiXoVdBRby06+nM9UC0YUmK+w23bGC04YBa1hVsIx+jx/LE6NNRSxHiQtXP3U3Od4t5b8P+ZQeJ7ICiJiPzP40MyhOdt2Z+FO8fXpsHCHi3ixmLk29L/ATZknz98b1thRtgf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 15:14:58 +0800, Chen Pei <cp0613@linux.alibaba.com> wrote:
> Describe the machine the KHO vmtest runner needs to boot riscv64, so the
> test stops being skipped on this architecture.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


