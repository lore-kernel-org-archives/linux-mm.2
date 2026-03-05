Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 100F7F47CD4
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 21:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE2BF6B0005; Thu,  5 Mar 2026 16:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAFA36B0089; Thu,  5 Mar 2026 16:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC4C6B008A; Thu,  5 Mar 2026 16:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9BFDE6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:22:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC6B38A5F2
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 21:22:36 +0000 (UTC)
X-FDA: 84513283512.29.030A2B6
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id EB9CE40008
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 21:22:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nsC0hr3H;
	spf=pass (imf17.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772745755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRV4KrgPufJHYoouG5oBzfgHa9sX1mic2JP1prCF/Sk=;
	b=0eNDeqY8oJs6fak2CtNNiuNKAherU8b9st8cx9eWym0chNSLvj6P3q+HTXST9pvMpNCXtA
	bUOX5FSPBeKjFUgwp+Gy8c1SLu1QWWvwxVAkfAMsdlFsJV39nNOUf+6JV2qdXfpbwjQxvA
	YZR0hXOnOLG6sgkhk9R2/tXpPL9fP1Q=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nsC0hr3H;
	spf=pass (imf17.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772745755; a=rsa-sha256;
	cv=pass;
	b=KSCFcti/sbEhI7YHnO8MGPBpgY8rESSTQX7w+JZuOd6J5ZqgLYjRLokHFlmk4hXyUzUS56
	Csv6x0LkiaVqL2sFC1Qy4kVHTYuvwbce6uimAav0x5Vng/1rrQ5emsohcGpdYvWhGPCq4K
	P3q3DkolzrU/C7cCUjPPTuIh2rhF/0g=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-797d6bde07fso5203117b3.2
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 13:22:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772745754; cv=none;
        d=google.com; s=arc-20240605;
        b=JBoMp1TcNSH50AShk2SijN8uhBChqGvITiwkm3I3oqY5vaYum8cv07Eu51hS4Vj3I1
         vs+5gtYW/Ae465FkipTiFnQ26cMUDLg7GWZKSitOT6PqUwq4CqUSzmpdtiAY/5200hXQ
         BHrHShUW7it3XfJJWTOT8YywuqI/KgS6IXxQf7Ul3jihAgFqdOhfpRiXTVQzpJiCxkgR
         E88dFYhnnj8hhUinOxSlF25s8AwismXiRnYE0d6RCDqZ+K2cxqZZXD8HAZYR/ynqE3MP
         8y8wLmaq+Vy2YcYNIZvJwownS9y0WVl8omAalq6ylvblVSR2giNjfvuDoREXnlr4r9Mj
         CnUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=xRV4KrgPufJHYoouG5oBzfgHa9sX1mic2JP1prCF/Sk=;
        fh=koBpkyoD9hfGdpoB0eEtBTM2Jn7RLK++ODdzRQatiIo=;
        b=NYgWSJtCvgeLBv6uY2dqiY2l5DBJOFWpfbAvJxjEcUGlUUNIhrWaPU+4dhDMHc5O29
         hrHo0OCOrmlmDpj/5U/HvYBrVYjaJbBX+oLW1ZdJ11lEKCKrNokID3fRrHuBgsG1XzmP
         8Cy/rCcguUu41Hy+QpIIv4SS1t7N+6zHkSK2e8267Q5suadM/ULU02uwPaYGdPMPzcCv
         4ydPUMB2FWC+uHkswE40de87McVRtqa9K+2nT73lKXxyNXLMwPoWaGaQYvTFgk0HPito
         +WBQUSy62X4NglQ62A0EgQRAu6DeX+6L6MrcTP8Si1UafQuaBNTq1pVg+L+eipli0e12
         Rq4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772745754; x=1773350554; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xRV4KrgPufJHYoouG5oBzfgHa9sX1mic2JP1prCF/Sk=;
        b=nsC0hr3Hadah4HoFjRppTAGckHu/FyJE6+bTR+PGsIy9w8unJL/hOfxt7uT5TL1bi3
         EFV1vgwEF/GxfJIB0nqZvSSzzfOhZLCI5ivpD3qAZkfRU8gb6heMlepQw9kyro+WJsFg
         q0MZHMRwHfqpZbA5nVCaXc3Qm44CEITaqcjB/rlgAqoKH3PjIP9TbMZbzYAhQF/jrJa+
         eJur8QhaO07+Me4afaOlPryHikSlUXDRRpFFkfHNfaH+91v3eICqf/O6w3l8Lb8DWgFp
         ZX2jh+8y3UeVZDB1xNTFGL9PxZnTqih0zUSx2iKFYS/l++0MERi3eXa1vv5ymLIhvAE/
         mCjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772745754; x=1773350554;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xRV4KrgPufJHYoouG5oBzfgHa9sX1mic2JP1prCF/Sk=;
        b=LntWvfr3iZkKenl9Gyhx1n9NyN1KFVj7n7zITmbwDy8vJsGG0BfpaFr7RBYpLNpfpp
         kOEXg464T51ZoLxnzy0nS+E5gPgMXvfcGZbxMui/ZtONhlA8LiqU88MotDsgQ+v/q7XC
         G5E+cEBVA+OVZT3uuy0ioaNMlmuLUn57z9C4AwFtfPqDp9sZF0K7Rtlf8ODxbjmfmqm/
         MxM/Vvsk+wSqeHzqdPImTtZMpXppaSmYSahMNHVCynT+WZIGMD3DivCDR5Gez41JXgve
         lK6XEk6znlPgydGidRyVICUrHyZxHuXPTDN+fdQt3jrF/eMIdFq7I2GUEnr2NqNWrKmR
         sBBA==
X-Forwarded-Encrypted: i=1; AJvYcCXP6Wn9x7WaLeL0eVDLElzDEww0cFmL7S3Lun2Oyko0zHNdu1T4XVxFZ/91l3kHwNCgWjeljpCT7A==@kvack.org
X-Gm-Message-State: AOJu0YwD1sHhHty8SpDAjyXeeJoDalo8xFUG02qckhTVibdARyAXqKdh
	tAVIVYCpYTsvyVzP89Kf/W7yF6okDB0N9bggjd3ZiRopbOPxHPw0bkqgFi8z1G1TWqLW7MXd2r0
	K+ps9ET0R4nKuSmJ0uHl4eAQeFEQsIu4=
X-Gm-Gg: ATEYQzxkUdb5gyYhSxtYp6YlNOwvCch3pvbFnutSvOig+YmYORICHHQz8B/YgX+o3cK
	ZunQees33AegjBqnOuB6qcw6IPRXtUZ9SojNBpp7hS/d6uT+maO82pHrIRYCOY03+hMcupyKTk7
	2TMMo8DTcoFjMcwU5IuPk5mIKOOtPDfPOFjJrkKBvECv6I1buVWh9LdvPRXUfOYNrNDX001tzeb
	llZDeLKpKyJpARXbhB7Fb9kfvONb9QwX6CupQ9fGfun72uGBggrd4Hf+25dGPnohturJSLOAyRM
	fFIMzF4D
X-Received: by 2002:a05:690c:385:b0:794:2fca:81a with SMTP id
 00721157ae682-798c6cdffacmr55975367b3.8.1772745753906; Thu, 05 Mar 2026
 13:22:33 -0800 (PST)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Fri, 6 Mar 2026 06:22:32 +0900
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Fri, 6 Mar 2026 06:22:32 +0900
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <aanievpHCv0Sz3Bf@wieczorr-mobl1.localdomain>
References: <cover.1770232424.git.m.wieczorretman@pm.me> <bd935d83b2fe3ddfedff052323a2b84e85061042.1770232424.git.m.wieczorretman@pm.me>
 <CAPAsAGxpHBqzppoKCrqvH0mfhEn6p0aEHR30ZifB3uv81v68EA@mail.gmail.com> <aanievpHCv0Sz3Bf@wieczorr-mobl1.localdomain>
MIME-Version: 1.0
Date: Fri, 6 Mar 2026 06:22:32 +0900
X-Gm-Features: AaiRm539DykMmBy-Zg-BtYOlfUPQKOJ6bwMQcvFff9WH9ZMuhoRcwF9c8D83p3A
Message-ID: <CAPAsAGyiukChPLYO_tQci-7Bvmnnxh+w=bO6eUYLrO3RVuUThw@mail.gmail.com>
Subject: Re: [PATCH v10 01/13] kasan: sw_tags: Use arithmetic shift for shadow computation
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Samuel Holland <samuel.holland@sifive.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, workflows@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: EB9CE40008
X-Stat-Signature: ormgc1snxraqwsa6nrhw4cf4jsstrwcf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772745754-52279
X-HE-Meta: U2FsdGVkX1+utFRZKxWHRWAgS2rC+Vx+SbaFEPSV08Q+dpQxf/GiZmOw4GAVfsl5twAw95oXCk+WrY5cTZj/1x5KkJq0lT15JIM9IfSvhJ9hgDm4jt3346vaytKdU1xSnNjCN+qltnwcWpEB2z3Efe6VQpmseo/Pyz6hM6A3IwG1dlr0ih7iM2rmuSIFl1F5p1V1f8xgkLlbSqWYrSX6uNzVOU6GqSBFPkxXOsKjO+gyvJF5qiF3fxkEQXa61Bd5ztfP4s5G/wYR4F+mDsNNohF0OIcIFlVddxHC48dEqS2EYlTudPpZtn2NkNpZAtvqo4YnU93wQ0wcC+sHWLM2qqU5zCmL564tqBryfBGyxJ2KZbw+etZ+5WEElHE31Joa4k2QjuLxQTVQ+63G6KjBt7ewlHcR43tjfRFXiyitVxR6nGJrPSPMA3tvT8XsLrxIaYujy1KpSnknfbhLRwVhWoASElLgoRXzX9C8r2WSF1MwRrCZ9KQGxXvI+lkel0UHRXrDfNGTeJtLhou2OT7ysM/NfugJ0D8ZAKsqORMCX6nd6fTbPJ+opJW38pvjHSU4NEBsiV/cGsBmjCa/EblVljnBKbS9GgLIvYWlcNlGvYrYFz7zmcGzH6bL6jJeJp8OvBjMUInclBaNbfLZQNiKLUXQszFnCbNZTujtwCd8Obd+iEG6z3se/VmYCFO5SwwvnN3y1iijpLy/stR+eOa1L6MqqfPQ20jICb6AJg8P01790yR22O5kFNLV7Gy3piL8WaQvhDfRNiIn8fxjoMPcpA8r+Lpb/5elD/jv6omeLzt4BSFcSBgsIxuFoobS8jvtwtscQgU1+pzCrieH+7FDYh+7cnjgUtNqoY0hL52AvC4ieisHifsKhrvt1SwEM+kYphaT90V6Dz0CGWXSdJG7mQl/F/vKr6tjmz8pWIzaftHw1AsghAQvhJcGiFoGLIBwcStFzrgcKnFRoQF2Wpn
 Bs0n2a3R
 C4ih5XlMlpX2L18Q1uiOLDY+cmD7WXH7tJCCBdFA26kiv5o+bO2X2QHXgLCd76lS/BB0TuTaX5aniejJHiNJTOrc8xHobxtjF7meApMedB+RTvQyGTHe9AX/Rhgeer1EgZQ9Mwreub+dRRHGiWVycDuxxZdlJzFDIxAKRVPx9x9+Ek5P1yFZFv5EM44hyvqOoXrL3rXgglgf6cpahkytSXU7MqkNPMs7aue0+7i5cSYqXuYnGPdQxLC5rXzvTaL8ltlEjrZpSZk1qNijPyiyrC38KrGqlp29nQGEzAtBebghKKgX5CMnjVzJCnGmrmvi4z5H5wzDKHrMQ1GuGv4QICd65WnHXgbZ1TWOdtFtxh8C5P6AgXJPhkhfjk2DV72osttSZEoud1BkpBNemctFTsk2mU71KPIXhUcEk1+FnKPi33hjH0qn9Co421Hb1tjZW35mF03QC1Qm94dx9Rs4veqExaYV7ynmCJryMonpRA6HkQV4j5KpH7syzeJ+qLrIqkCE9Og7M3TxABrUHC19o4wLqjplXh6DuV9U5C6ofak9GrxDEwS2bVkXGeUjzO+0L2rcBPsLArteVV8r02DAk3+9bua2xhmuJkvHg7mj1YVcTt+hLpd44y2T7b9AXBAXACdncWZSm8HVnZ5Z1fSgX+p6y5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Maciej Wieczor-Retman <m.wieczorretman@pm.me> writes:

> Thanks, that looks really neat! I should've thought of that instead of making
> separate arch versions :)
>
> Do you want me to attach the code you posted here to this patchset or do you
> intend to post it yourself?

I think you can just squash my diff into the subject patch.

