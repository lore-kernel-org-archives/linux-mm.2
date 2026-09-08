Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B0A1C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2797B6B00AC; Tue,  8 Sep 2026 09:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22B7A6B00AD; Tue,  8 Sep 2026 09:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2ED6B00AE; Tue,  8 Sep 2026 09:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8CF46B00AC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:20:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3B16C06BA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:20:26 +0000 (UTC)
X-FDA: 85190654052.27.9F1AC4C
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id EFE5880006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:20:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PySpF/fQ";
	spf=pass (imf02.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788873624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZI1g/vHb9cji6vCcQ+uARVz1H8o1gKWXi33ujmqGvdo=;
	b=59Dw6wIFLzcoMGK7YJ84n+Ux1YSgWWMj+DHqfgFtqpXJn+mDxP1AigRZtuVBdiiBHSO5ft
	Rsm2D8yFqF0EwXDuJ97aQwmU/Gdjaereh6XDRekzmMWPMYLox4CygxhRj4dJ4frcOzqlAV
	7mqGD9ri+O3XuZvtdv1GFQjko5FfBf0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PySpF/fQ";
	spf=pass (imf02.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788873624;
	b=PtwFyOCN9dUPltAbSPoLGe1eiFpsEatYyOAbv2MCAnXwmo5EAnESzYTQ2GSDtMaeLDchb+
	uZNhFBtymcnv7C/r0ZKGveQYixE0xLtF6AkYy+iBw4Dja4tPndTmG1u4E/O8B4BxEdaOg+
	qA6SsPicH/m4vFst59BuMprmKSZV96A=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-484374f54d0so2971720f8f.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788873623; x=1789478423; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZI1g/vHb9cji6vCcQ+uARVz1H8o1gKWXi33ujmqGvdo=;
        b=PySpF/fQN0Kd9tzuRH1zWnooVuaVtteWqg7zRbafv/ttRjRKVjFU6Kc2d8trZaQibb
         qwfMkhy7J4wU7RybIOZjZn8oCTgdsfrQ/pfhFP6S4Zkw3hgqanO7snSydpRx8+DGYS0c
         oPYhypmkuc0tuaMcWfVcrWkA6gNT+WbFzzzPxU45IQWChz+Jv+GwNneDKkQmqMojNdDt
         KqZDTMVN7RIQpt5rE8wEAjwtsgZAaeX7VbJkazN/YYUc5xmaOJMdmCyaSPmyQjToraOZ
         T0ZcXV4VyV1JRVKmSEW1/ARlEna0uCrHAg1GjZa70YaoPyrizLhPsMKwogNqyX9HNFL2
         1WRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788873623; x=1789478423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZI1g/vHb9cji6vCcQ+uARVz1H8o1gKWXi33ujmqGvdo=;
        b=hM+qbT1WmaJlE87SSuACDlyNVV7a015gSja7QaPh5q5jtXAzZg80izCkxkyDmNYL7K
         fNETzLV3tfhbRF3/2HOZeMol+MG+9bsG0UzmHmTSzK5cVvEkrV7Ul0F7S3joxPw+oDxf
         3cL1VYwOR27JgGCNwEEYucU2KPAWY2JsVlQhdP+z8ets8mdQLC98Xt2ExnkgjbwcE81D
         HWetwQJvrbvwlcbWXhvq1SC3p3SJk0DOziAgDyk1S6iVGwr1tEZTlEn//+A7OiAO3z0K
         9faMGDm1kLTjKKwlYs9EGOAEsMS2pwJS5xoBOkwbTMqMMlk1asKvKSa4HphpsjtABCmz
         s1fA==
X-Forwarded-Encrypted: i=1; AKwUvByjpE/8OH2RLczuTen3dbvGua4LsbYATC/NntIF6bnAYlCWyWYXDDTHmOedHHTvQcnySxd+Atzshg==@kvack.org
X-Gm-Message-State: AFuF++laritIyV7MBnYxsa+ui/mS/zTstnUmIWNLJQLWHHBDpxu8Uysq
	Nf7NdDWmbgjnwjBXXYShVkjPRJkU1b+pgZK4tzKfTFFdtXckRNUG47KI
X-Gm-Gg: AYBFou2mNWEWrsqJtiwAexHrFPgdZE03+S7AuYLoxIQ1ixjzioEQ/E86kdI1AWpdEa4
	JKMJ38RHMfaO/VJy+AcUSqSn0nPHX9rRbgofxuPi9Z2SiOnJAWYXRZ9jhEpmCvEMaiBdklNbgeC
	EAdaS8y6ramUzbvfQ2vtzsb7CSsaXRWVluvK3v8cyhAJMIYdwtdCnsDb9wrJ9NNOpYVbqza0qoc
	p+vnsduEC3kkITw9jvRld26MNK1pTo2lreMgYCa9BBBRN4HiaS/4VMozrxMoBbPrZtxh/Mo8Esx
	3Zm+LXnuw11YZbc4CCTN3PRAzUa6D+RkQgL3eTG1VROndL/I2dVPufOo5NI2hv3QNRQeZpqQ7hD
	ZX52suGs1osco/Lfip8eHV96hNf7GEtzF8Xr0C9KQU5GMCzRXenYcyG+nxOglJUiCbuNLSwDdO8
	bULqGoq7N9EnLbvhlcOz29q3mpFhNpSnhwcXVw+sK7XDK9f67mMZ3UrjelZL4Wjv2qIYuB5nKTL
	g==
X-Received: by 2002:a5d:59c9:0:b0:485:8420:26d with SMTP id ffacd0b85a97d-48587057223mr56490158f8f.8.1788873623214;
        Tue, 08 Sep 2026 06:20:23 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883c074asm35214027f8f.23.2026.09.08.06.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:20:22 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: tasos.papagiannnis@gmail.com
Cc: akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	david@kernel.org,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next v5 4/7] bpf: Allow reads through trusted-or-null BTF pointers
Date: Tue,  8 Sep 2026 16:19:39 +0300
Message-ID: <20260908131939.73400-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908114736.5342-1-tasos.papagiannnis@gmail.com>
References: <20260908114736.5342-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EFE5880006
X-Stat-Signature: p4d3tpidubou14ofamtznu4bk4f6qgos
X-Rspam-User: 
X-HE-Tag: 1788873624-993952
X-HE-Meta: U2FsdGVkX1/h/KLYFiMePq2SnjPFfQasvXQS9eNHZbdHMjsk/jWvBLrQ0chHRzcmih/PXLcDPhCMq9G8zH+7dyebOFYAxYkfvfWGOSWO0QVtAFVLHXCXJ97LnzHeg7MC314AYVw1E/V1GcGtMP/zZXF8TOONRJHy/1gbfw9qCQVaXsKn+dltmECBr9wlSAyCxgwlxK72LNgQe/LmP/KCO095mTyoRFp3JoVUYCHHz3GC0AuZH3zzwuJXOqfQahSW86p4EPdHLF+vhKR8lLkGgVQxzAX65pD8JBjcRPs/lQBnjqkEkJS3+eRHrWnrRjt07xVml/osbQwnLkLPGuKb0fOvKgnykU+lWNYlaqWLYMx0yi6zhF/LIvElUt1vaz5fmuiR2pkgsPMdfToDIlBLn3GrgOCoXU0pwez7FkU3BdpMAyKogYl0zzinQanA3i14Xe7DuOKRz74m33DmJ3g9rZOoVFBuDs1G8DkCR32pLrhyIzZunKbkKcxUfKh3u3Ib3lM9g7b0IIPRzZX+UxPJ0eQ8UDmiN5jyqYYWwwLxUHgR7X6uX57QCzhZlYgakA/uXr9KjPWpelQlz4nghvDkHiTHReYrGr5ETgPvMMPgsz5E1m6i72eRehzonUiCy7sr1pOYFb8HCBV3Jxhru6//ncWoj8e7j4R8XPv5UvNp3k7R0k9ajpIgtQgp8nIb7wg/SSNGEge5211ohvgzPbtDTXsJe4cWhc5/Y3/Hx+mYzdu+fNUnBc0pPqLIU3SPyuwD0CcHhRQjFl29bEBx/7i3RMY9dqYsxvb+Ap9yNEeqQUt3L2sofY+Xv19BCbu2kh/oGukmghNg6MzQw0L3CTiAouoRgQv/i2EfvwxbTNlXIyDwhQHDR6509ZXJbYMn1Z3oHNUNZL0PgZhLVJOs4Ucr1PJGBtUT8AZIZxJmkelUt5GwVfB9Zw59eKJcYlFqd2oruosK+fx+EKV8mQHXNLa
 v1pqUcYM
 SiEUDSETGviryydhXhma6nIHeZwWhoY3EZ1oe1xAVDQmeTOzYW1bQHuSUk8t+58gJt8XdBf0k0iowZj3ao/1I0eQuH7QMBFDWI2BO+OTOmpiLqoYrJqaN4Q228NlulPZBUnLQIbNlbj3LxR8qTUM287Lxpg2f4bHCi70aidXtR0zbwDoz06kHsxp3N8LWjEY6dVdD1BSVhJT3JHPz5sW0XReSnyIuqldmT+pxCuzLDXslKyG/kyMS9qXqE2q1aXDR5XdBwSmNcqW02pH7aSpH3iN0LzWNM7sznkyyfLJYwUu2v6ktxaXi33UCiNIctyJFrBkNnft51nkDQBfq4SvAOn3Fpm12LUiLgm8LvB3/WdvyiHbg8BkoYfrvlSuYXodoxLJWhfqgrkfIGvSlEqMSOKqYcKWvaAerHaPb8AUgIrT2KWVVWZ13EDh7laVUn4bJUQ1a+ROp/u2P+z+S3xR7l6WNoTyyB7NO2yJ3gndh2cVKs5OGiIU5aRUnabYXfEWImeFKhu52yOebwaocBfBh7/pdoraRdDXQYXyLRv6pR2nF4m0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Out of curiosity, what were the main issues caused by that change?

Found the discussions in [1] and [2].

[1] https://lore.kernel.org/bpf/20241213221929.3495062-2-memxor@gmail.com/
[2] https://lore.kernel.org/bpf/20241206161053.809580-1-memxor@gmail.com/

