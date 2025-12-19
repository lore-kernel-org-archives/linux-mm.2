Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA8FDE66895
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0CD6B0096; Fri, 19 Dec 2025 16:38:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29AF26B009B; Fri, 19 Dec 2025 16:38:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19CD26B009D; Fri, 19 Dec 2025 16:38:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 091FE6B0096
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:38:19 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE6E58A597
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:38:18 +0000 (UTC)
X-FDA: 84237534276.18.A40E285
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	by imf05.hostedemail.com (Postfix) with ESMTP id BCF3E100014
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:38:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c2xbR6GJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of bart.vanassche@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=bart.vanassche@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766180296; a=rsa-sha256;
	cv=none;
	b=nSKfJlWbVVaSycsCJ1m6gTOeFFBKG2TpbeqqF0hmeNF3avI9Puyep9QyJ6S9AwGjYuDrrA
	f1iVSubK9Tp3OlXlvJCIREAB/uSh0i2Q6OhlPU3p7V9COeBkIH1PvVkRCCUI6ecDDgN3xO
	/sxmSRL6JhLlBAgJmlQS0KUJrc+3irE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c2xbR6GJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of bart.vanassche@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=bart.vanassche@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766180296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SBHXkRgMesGUJGSlI+YkckhHJhyJOUbeeY6s/H5FeUc=;
	b=c9G6yKOOcwr/U6QsNwnOjQdmGhCLeBMXx/vD3RkLyE32yE5XCqIPpTh29IikdSciog/Mxb
	0DChrWEsw5smaRTefJm6C5bDaYiuj7PqPXi7Ki+IYun0SWsF3Mx+482kk2Ez6U2OzCOrjl
	0o3Dp1t0aq5zmaVzATcHlZSujVI/VU4=
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2a0d52768ccso27772115ad.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766180295; x=1766785095; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SBHXkRgMesGUJGSlI+YkckhHJhyJOUbeeY6s/H5FeUc=;
        b=c2xbR6GJwnrKU6KyALcnr3Pyooa2PMCf7PiD1dfkToTbtA0CaZnPZGb0JXI2KQkDV8
         RR5ZfwYs1GmeHznLxNEvJLo0NfesPgwCbAv3PuDyQnGGajmW+6FWDrI0bHuOfkn3CgyX
         PxK823zZjd7AhKrOoYFGfw7HSIyp+HaJ6wX+5zXWyiNp9pUvyLB6w6z5eqV9JAUKwS52
         vWTKgyLYthI/9FcpA6BCSlFXLtdAIxshbHSxNsvEcywNcHwXvF2CIbuRb8x5uhU83nFy
         rmJgsXSY13xVPqOELdfHkBjWoyKvNB6kWEarGy+yf5VRx4fUN/CD8sRQr/AQ2yJh+pXI
         Ryug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766180296; x=1766785096;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SBHXkRgMesGUJGSlI+YkckhHJhyJOUbeeY6s/H5FeUc=;
        b=HgY55r+02omRhalDRpv97gh0Iz8YGYp7+E7HDzs7llf0d0SmBcPyGEMKB02eDJecNa
         /5wThy7yCacNT7Hg91KCkO4WvdVO/W+w9cWQfYUWwmnkBXn0wW9bYpumFKrto8+Vnt2v
         UXFu8jEACt3Mba5t3fxKDfJT4RUjkIPLAZzmuB/npEVvweS2jBpO6rhkJtdFyAn7oaBV
         hZt5IhXSv/pfVDDpAFoY55/vTHjh88LcHPiQElCaxbqIK9QNbBopp0HS3zhOhTaNbjxr
         GJXBSjvMKoQIyfvMrSiw3o4HN8MT6mzd0MrGt1P9uXSj6kBlCVPcWrEfNXn3uSE750am
         AKUA==
X-Forwarded-Encrypted: i=1; AJvYcCUWCndViGhJHwN9hV0aJLsjBeTMYCLoDzVlge8qxm0PZZD4zeOiLYTNutlM3gyieb8E2N/00JM8Wg==@kvack.org
X-Gm-Message-State: AOJu0YybK14w8Rxk/4WLPXnAdPuUdIRjAHOAZ35/ZajRn3BEaWv5HqTY
	+garGXNABfuPWJMvqRqkedKCr3UWZ7s1K6a/9QKm2wp0OCtx9CgITTJ3
X-Gm-Gg: AY/fxX5mwDitgGoPEDlVP/WVwbFXGgQU1uGEvG07rkP65pRPUcQpg/B9nWd61zewFPK
	BHFMDXcPbh3U8W+ieN6piuvsXn9zzC1SZcFfHIbxPVqVMd/JHc7IjI2J1u4VWUJ3mN5c2AH2FMz
	0h2yktPe/XKQf2SH4SqB4GHKM6SiRolCygj2sfIIhSBm6zQeP+ShhpNMkh772dLy+U2Mq19v9XZ
	F7J+HncmweExa7/MZ5zlrTxvgCsbBLyyjIORNF6NuyLIHPZwsROwdIo3MNUs47nYN0FexT0u0AD
	icYBsaeaUDReO5HP0Fvy2MTf1EnKf+dn5Y8z+y+11jFW9dceHi03NQm6wZojKZBoVFeRWtGMqn9
	hpe2kXsIMt2FLGIcphrLrQXC6VicTinvFySksGhs7OzypyQG71P90OMwaYmV+UY7aNghY5rYbPD
	t7M+Boj6BaC1xwMNKXvTuos1O+zbQtnce/jwgH5551RYaYgv+Gpmzq3t6vyKoz1d7kmVccI+FE9
	7/q3sTzbNWiToqEXlPtbeUVPetxk4NbzlUT7BC2ZEZ/2U75x32QbRj/8v98OzLQQDgod48lFMLj
	R+c=
X-Google-Smtp-Source: AGHT+IGivulZwqOvq9TkwT/0JBobQprm3JRJ6VtJUw4ydSXEmlT/iKTWxEeMw8/Q4ZWRYLdEwZEKQQ==
X-Received: by 2002:a05:7022:e0c:b0:11a:f5e0:dc8 with SMTP id a92af1059eb24-121722f462emr3455845c88.28.1766180295388;
        Fri, 19 Dec 2025 13:38:15 -0800 (PST)
Received: from ?IPV6:2a00:79e0:2e7c:8:5874:79f3:80da:a7a3? ([2a00:79e0:2e7c:8:5874:79f3:80da:a7a3])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724cfd95sm12051531c88.1.2025.12.19.13.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 13:38:14 -0800 (PST)
Message-ID: <34cda24f-acdc-4049-9869-b666b08897d9@gmail.com>
Date: Fri, 19 Dec 2025 14:38:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 23/36] compiler-context-analysis: Remove Sparse support
To: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-24-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <20251219154418.3592607-24-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BCF3E100014
X-Stat-Signature: 1r9by7x1o47bkw7g1f8hcup6ok9hkj8e
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766180296-858211
X-HE-Meta: U2FsdGVkX1+u/XKdRxQ6cmSB0uiOXQefRWXdq7Qnhb9JqoNJ2ZB1nErhoXcjPBsJmzvaEKDd6IOlcTHChQ26FWs4FEjH3zYGFXA2kp0sWjWOTeZUWFAfq0GnH5fgqU3qAp7KBulnCLrcdN0R9Fx4dDTlxeIg6eIch8QEppwtPOAOL5Nl3e1qFU6Ee7UotUyZajgALqb50lipwa3mdGRxVMdT3CGf2g5QzdlsCODntt89hfFutK7F5CG40DOe0+CgL9qRcRe3BqwQLJGZ7IC0vb9bT59ZdBMc8cKTsuOiODRP3I4+8uVQJXy4xgXSOmjFVa9BkeGSSzgbXDJ5ExVq6CAhnKWHYb0pNT6cK7LdDGWU6kxaqoSPEno7iq8+FHPxZLmSPUKSwVjH+b313ExqKKVcOSubnTY9odizQ8xPYcJH1RW9aVfHvh2bhNdA5LpCun/3au04cQVA+PRl2W25W4aSrpi7bgvQFGQVYjiiLEq00suku5rU/NCn+B3KzMDx02J7NWYvPCqzEfQKP4yUJLAGcWrq3S/tQbZAY9PxiKbyYXOfPVL5Fhjz/I9/dcNBP3ZriTuLpCMAIeH3KbVG5u4LuvLLcLAgsGTsIGm9wLZyAHhqy1M0BNIhR7V1edghnn9Rpz3hgnmmbqLSZ3agS+XPwoILmEscD8YV33vKu3X50jvNpt0zRheYSc27gd9UHNmkn8fD8jxVGzTfSrTQg298/XSeno4jvfHFMyAQK5s4aLaSndNAxX0wFK93deicCO4BGGkoG2yPTOqUiwkAwt/nv2oZGvZ5wl/81DaWwDRv4G0AcXrEfOsL2QSLr1+eiEZr9byulwa2BQzco2swI2esIUGUxLiIc8D54QPLansb1BKTxRzMExRx3uuVcotvTUBDTHJrzFWV5UhZCH/q+hwxqVtYBp4eqfHUuBWh33MM63BbgPdx4DH7clTfl+ci0BPKcgIoiOr/SX1pfuI
 NgNGIS8d
 Njbh0tHit6dhCXnOdkPMlWTqsrXI7XD2T5g2r0oEfggmx6vecf4dMebY9jEvOWpmLHv4VO9VQx/+gGAm6zYKYzcFRP5RWAVrDpqqSzDYavi0jrFqt12Mk5uhZrYpPROnogmuJJfX0Lzatu6VRB+rpy7ZSzu43hkRAIIulqKDGTG9XwttI1g7CfE4tBhjQcRX5MGk+Iqpo3LcCm3/ws9eOs7lXKRLdvRu4e1QcCxJVsPVOs39Z/nc6VPtdvNVKzHBjIHwyPy3NUYE+FEta4yPjPRq2WQu0Yj2LCKNmmaNpTbU8Expv8azeqeTUGBgLH81nZ8NDwo1AwfkMCwZdpSyqj62JuHIFJEpQ3EAQUcqBcVOuQEK4ls9GbyuMsxfVtyO+zCziuOhD/Db4giCuEvugNm6ptWXgYKh1nwcTE8X9BZjZgD1/bEbvdvq/6pR4IBo4SbPhRP3W/hAVUjCbPdy7mqi32I4qvuJHy2A9APWrnOwY/nlR/0nZhjVThdZwndOl0C9BEsjSrtBn31kju92FlUZMd8Ybjgamkyhbx2nvuzyMsIMSTwlVSPC5KLLRpptlqKwsM7Y4gS6uk34IxyZgJEZuOuwd99yyqlOpcxtlzhpHB+jbnku0zeWT7908dpi3iumHKCSX4cSdWX9bljR9LTjRz5AL5qUE+P/M01z3auZFccE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 8:40 AM, Marco Elver wrote:
> Remove Sparse support as discussed at [1].

Kernel patch descriptions should be self-contained. In other words, the
conclusion from [1] should be summarized in the patch description
instead of only referring to that discussion with a hyperlink.

Thanks,

Bart.

