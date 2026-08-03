Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8787C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3D536B009E; Mon,  3 Aug 2026 09:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC61C6B00A0; Mon,  3 Aug 2026 09:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D826B00A2; Mon,  3 Aug 2026 09:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76EEE6B009E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:17:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C12B406DE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:02:16 +0000 (UTC)
X-FDA: 85059820272.10.EA451D7
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 154011C0016
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:02:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EnouUtAw;
	spf=pass (imf21.hostedemail.com: domain of ruirui.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=ruirui.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785758534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52EZk8YPwTy+jG8rvfx/kfwJ0amdCbdlhZF4BPxa9n0=;
	b=XMf2T68scyjpST1MrX1WjLFUywCLAUbDRDNtGgbjAi7etew0Hvy6nJXQxTLqAHNe8tADYT
	pFVi5kntVFydTLoGE5b7B0Ivf8VlY+QCAKvxl2dhL9nn17xsCH2naibPhX4fN5qKhCyre1
	S6TBjagwyX7RxDDaG/zRpVq1e/6cHGw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EnouUtAw;
	spf=pass (imf21.hostedemail.com: domain of ruirui.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=ruirui.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785758534;
	b=n5yimsQ05lC68R9RR/I5Pj7sEsD3A3yWUzMmXFIVeuxQy87xjWXBhoHVQNZ4DA93oVqnJX
	O4QH+WhnWWmyR2+16Sy4WEZiWnTPBw/EAiiJg6TMS+Wu1G/WB5VnuUYYgRFBDU9AxzQau4
	Ve3rD8Qd25uFDYr7VlHmeXlW06Ub76Y=
Message-ID: <d5513f7a-6a69-44ad-ab3a-095cba0d1cb8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785758532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=52EZk8YPwTy+jG8rvfx/kfwJ0amdCbdlhZF4BPxa9n0=;
	b=EnouUtAwmdUyiYMkNZYeTEKz+AWGqvGLFPzrRg2VSPbHDC6HVF7FROS4eLHrg3gT8tooRk
	rig62DQPA5EaSsWXf6iA3G0v/XDaJ6BmV1oe49+5hzRGn2f3z2n2yirXt1Il6HlfYyxdck
	yb7BufJLbG3lqJtL+aY1dN0OwdZGnlw=
Date: Mon, 3 Aug 2026 20:00:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] CRASH_ZEROIZE: Wipe secrets before kdump
To: David Howells <dhowells@redhat.com>
Cc: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>,
 Baoquan He <baoquan.he@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Jarkko Sakkinen <jarkko@kernel.org>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>,
 Coiby Xu <coxu@redhat.com>, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 keyrings@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 Tao Liu <ltao@redhat.com>
References: <79610b53-5201-4af3-913a-0c4dcbb6f9d6@linux.dev>
 <20260731154608.153258-1-linux@jaseg.de> <am38qk60mpVFuJRi@MiWiFi-R3L-srv>
 <74625f78-15ea-439f-b9f0-939d2976fa7f@jaseg.de>
 <2490025.1785751199@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dave Young <ruirui.yang@linux.dev>
In-Reply-To: <2490025.1785751199@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 154011C0016
X-Rspam-User: 
X-Stat-Signature: nk8zdqjtf35jydziyyrtrajgwu9tbs1e
X-Rspamd-Server: rspam04
X-HE-Tag: 1785758533-617638
X-HE-Meta: U2FsdGVkX1/JdMfmyFYTqeBXj95+jultvmO9k2h9ajunYrIbcDZ5wq4KyRZpqLMI8aUlm6kMRVTo8rPUB4V8JbaAa+qH2fT5yMeETIb5yCE1Y3JzlrK7SFcaQkYOb7IpzjfhQ/aaDSyqWy+Te6OJIy14LouiQ6q+Ev/iceXuTLAMheSI8AqOvk+HOuPiDPsTfT32upNwnIY4ae836NBQoyhSpSCPMRwjMvGVA7sD8E+xDQTFN4deQhhI9yH2iC+1bGk0dDK0UOu8UxdFmED4iIFHa/Gg4Kw7s2PklboU2/+OuF7+V2/wHlgCkZWgHLeybeyfpGVsVS8ZUQ/vrJRUoEtp12CfEGb4WCslL7gkJ4XhRC1Vzx88M5DG3cyqr3B1sEWgq7aw+cpmK/wYDv6CGkGn0Bz54/HbndGP3xx/h+3H8XEFd4RXX6zxXVFdpn/y/Stzgr4OcTFvnlgcTDVfKw7zm7mFbTiSvHCY7bG15xMNgn98K3KKjQXML1EBIOWppa7JeceyUQ6vFPGEGdA+VF8fhj9fST0tbcTnvCjVSgYBtjMw1EJKxSEYy+/Mjrb9bChmKNYw+TwlqDZIyb5nUxwg4o8FFsza3M9gs8Zjc8UHk4pHtwWpEdoYJVIh1L51347e2z1LlB1YkEunZjlSJH7RUu0JHi/hz4xDqK6zi/QeLYw7uxKqAuzsSQfPQxT+Z+I+mbNZo1p9f5e1hXOlSgymOsFynVRcjdUfobc/Loqaw6UoB0qzBL7sUwnoh42HL3fHrN2P6o/uDAUS5QEIxKtJlN/nEMVQ3XU6hskF3Hl8VKw43DlyhsHWI0gysVfvTr176YLRBZkdlEvhfa21B6IPD+/VfSzNVTOqtSWu64Lyui2AukpMwpFQwTq5Mrx9VbzFNDW/sbLS5qplfQM9aLt10a6W2CQlD6sdf55MjSZsKj7RA3JSQkBy9LDkellWnzmDJ8/qSrAVI1rlhIA
 NZU1qfNx
 EzHleyfc2pgtfSBq1BS1rz6ri99Jippq2CawP8Sg/IVG4qAxhC0igra7bA1Qt2iS1/dqVEdMAn9OkZ+pud1qpw9OfXDLsanAAjXJ1DxylnYQ/ATtMCUp3fZ7KQVV0nt8LCD+MHa683h92CDaBDMCDuuaATyqiZfdHyjN0YIL3JHgBnqBiDpOTvjrshHWwm8B/fh9aAyvwYnqpOdy2qWvzTcV2lKo2W180RzMECBtLXJz2DxBkRcuVUrAY4I0J1AdYUl3DqTlQQsASG6KcrcKy3D/ajINvk+X8v6FHjnSJSEkn3u7w/D0P8eHLRYrJATRaVu+B5S/IZx4SGAcIy+ecOUJ4C41MkZx8sa8Ds54kQZHJe1M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 5:59 PM, David Howells wrote:
> Dave Young <ruirui.yang@linux.dev> wrote:
> 
>> Cleaning up secret data can be done with makedumpfile + eppic scripts (see
>> the manual of makedumpfile), or it is even possible to do so in kdump kernel
>> with Tao Liu's improvments for makedumpfile previously (I don't know the
>> status, probably dropped for the time being, but it is possible, cced him).
> 
> Does this represent a leak of the secrets?  Also do governmental
> standardisation bodies have opinions on what constitutes a leak?

It depends, for the crash case I'm not against to clear sensitive data, the
concern is to avoid extra complexity of logic pre-kdump.   Which
government?  Sorry I can not answer here.  

> 
> David
> 

