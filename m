Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEA0DCD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 21:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5006B6B0088; Wed,  6 May 2026 17:17:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7FA6B008A; Wed,  6 May 2026 17:17:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EDB56B008C; Wed,  6 May 2026 17:17:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3966B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 17:17:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF667A0321
	for <linux-mm@kvack.org>; Wed,  6 May 2026 21:17:46 +0000 (UTC)
X-FDA: 84738256932.23.8624569
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id CE1DF10000A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 21:17:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZOL6Xt6s;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778102264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qct9180ue/H0QODWWGitx8QQGo9oBwuKWknYkPEnMTk=;
	b=pGzvguASKurO3fbexeGZLIm1R+KeVTEK9HkJOGimTkAUlT4TWX/S+nQqMa87idENKbkTec
	ENEXrEyDzBPS4g2Ri0oc1COF/IB254phlPKMyg/tNcnT+UZt3JtQJnnJH0DWenq1BUDq2e
	ZYYMVfLSBlXhab1b0R/Z1pMzC5DvS8U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZOL6Xt6s;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778102264; a=rsa-sha256;
	cv=none;
	b=24qsZ1VgSWQhxLaZ7+ab3ydqmiuMM0zrYgPonN1ikMjXT7RU4ybKcR3woBgmQiJwY3fUMG
	00X/grZ0Ha3Uv/a9OFN5245hRP7//jiXLQHzbeXMMAxkBesbhAUInUre44uqe4JUczm+mV
	RrOfQ4zBfonr1PdcX47K56J+00adfTs=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso1357345e9.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 14:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778102263; x=1778707063; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qct9180ue/H0QODWWGitx8QQGo9oBwuKWknYkPEnMTk=;
        b=ZOL6Xt6sR4VF6NoJ4xaTAUjxXmUUdeeakeGhmS9AgX3Y/oEKmLPbCcknAOratraCFh
         Im0+ApeAH8LZp+73RJ7jK9RKxPhZyzScZntqROAMdQG2coN0/KRoguVFpBxFRgz5a6m0
         seDoL+4gaDChilzSzqEUgHAtv6FHsdlaMU33lBcwxuDUK2NmS5eok6IH6UTJSQL9xr0H
         8E0Qwi/bpNh1yLbYi42pZqt/sXhh5Riom9oa01BEaCYpVihL654iTMLF2k2wcUY+5Pem
         8LblQvot5UPfuzgOBWFKrKTxxSJdXoJCKQbbH33ecDDXAoRt0gMvHWTE3wh7rHDqVIP9
         z4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778102263; x=1778707063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qct9180ue/H0QODWWGitx8QQGo9oBwuKWknYkPEnMTk=;
        b=QSpbcvrMHC7+J82dgvPhI0bMNMW+Qd3DKgObSZRv9fHVjdWXpmxi7ORzUaSayzTPHo
         d8EF2Fsv2t5UDXoRsYlTr9XZMwNXhWUyrCir0beHqwmYXAg54UkFLQbthw07OYBZplPp
         JHbgBZMOQknAvHh7PrL0slxRQ8GoKdDbQd+2U+U2g0YCQNG9s99q88KaGSf2cOzSTA6G
         h9Lbn37QdJGw40uywZujeBAoaQWMXJ5onqPzMt05+XP45P8x6Ku9F44/OC2lW+5hc3LO
         dhgTTKYAtwOpMpGTP4GiIcs54PbPi9TQ3ssse99i9OIpokzkujvEnPMpizGTa/oAf/zp
         98hQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ilNMt5wzUevBpvxVvb1wDzlHatFKL8W2sYdt0nMLefo91sv4jsFKXgXBKS2M89e+SkdcvJbBWFQ==@kvack.org
X-Gm-Message-State: AOJu0Yxx8Z3nKu/ASbHyHcvKxLN+eP1Lf4mHGyjt/GqgVxHGxbAoixke
	PI/tiwynN8JSW3/vuCueIHP6m+Mztyy/t3fDWdn4lnc/Uu99wyLxMUfY
X-Gm-Gg: AeBDieukUU9rX3tHhFMGN+h+E5UWx8itjfIAV9uihgXwg90tQKsxxOCaUlHsxUd4Td7
	bFx8OcQPEUK4wOzYBJEw/UACeIigMeXD8yQA4NfFvcvivg9ErQCPsREbTA4CyUTRJgIOfmphaYt
	jRmEDXabdaYZnirRcrNZoY+VkP2lt7CCZqOo4xYXCRpsomDGhX6SkMXsRSwadShXVtJ+5x56OuF
	yOwWMizbqYrQvijmSKsdIrk5qC1agX1A74HKXxXS3C3KO9Oa2ptlpD/q4yookyBOLD6IoDqUY2m
	ggPMgY3xdEAmci5X6hE0dAawQqEbVFlBKIIkPPmWi1eibttL2LN9KcfjMZ5D4X9zXJO63K7uQL8
	djC5wBZyZRB4nnF7VPlDHCFjVyUWkGAeDjOo+mf235YHQfMd+dj7Cf+5QUnutr2a8W8ZEWc8yC/
	vy/8acQvUMdlcdgRbp0yjQdfTOg8jxCWiKlTzLAsnjNuJOfooJdjwxC5Or+8WZmtraG/HOzJk=
X-Received: by 2002:a05:600c:696:b0:489:1c1f:35df with SMTP id 5b1f17b1804b1-48e51e215a4mr45435345e9.10.1778102263311;
        Wed, 06 May 2026 14:17:43 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e530c3a18sm24141125e9.11.2026.05.06.14.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 14:17:43 -0700 (PDT)
Date: Wed, 6 May 2026 22:17:41 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Jens Remus <jremus@linux.ibm.com>
Cc: Steven Rostedt <rostedt@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, x86@kernel.org, bpf@vger.kernel.org,
 linux-mm@kvack.org, Namhyung Kim <namhyung@kernel.org>, Andrii Nakryiko
 <andrii@kernel.org>, "Jose E. Marchesi" <jemarch@gnu.org>, Beau Belgrave
 <beaub@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>, "Carlos
 O'Donell" <codonell@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>, "Steven Rostedt
 (Google)" <rostedt@goodmis.org>, Indu Bhagat <ibhagatgnu@gmail.com>, Peter
 Zijlstra <peterz@infradead.org>, Dylan Hatch <dylanbhatch@google.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
Subject: Re: [PATCH v14 04/19] x86/uaccess: Add unsafe_copy_from_user()
 implementation
Message-ID: <20260506221741.44693d87@pumpkin>
In-Reply-To: <20260506221358.55ba5187@pumpkin>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
	<20260505121718.3572346-5-jremus@linux.ibm.com>
	<9f85f092-c376-4350-9a12-479d7b70399a@linux.ibm.com>
	<20260506221358.55ba5187@pumpkin>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: criufwondr617bcatybiueqgcwmr4ywj
X-Rspamd-Queue-Id: CE1DF10000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778102264-690847
X-HE-Meta: U2FsdGVkX19hyGimdhNzqPjug1ixKpa7IsicKfhNpoz6jlcqfthcZrtcfdLsWQ2ljGk0vA15YvJyzyutTxXLbZJOV7JQF36vsmKX8xm/K7lLAEH1GDD702cP1ctXjFziFUhGs55wWxHPCCjtQCozXhbFwmbNHullWbkQuD3mJM7uFMvNbiXQeIM3sXEqn6eLGdI7fzZJqp6HSbzc1l1UmbE7hko792muu332q0HgCWovWNadydKSM5iA5EzWQL7GMS/WX+4FPQ2L9zIkCuUNJtIscdnEllkrwXB0a4svlOBL3yXrIZPC0rg+0A3rPTPdC+HveSgq5bsd70sORqFQdCEcM1KJibwBSPKNdBwKI8B4xAwRmWNZwCA9qc3q6nQSZCX+WrJxT9RDFiTXPSbKbOThifkkSC/WDbzPmPX4wKiSMiyuHwBQCOrJBNWCL5YZMx0oLKCzLd1tqKnNAF49DuFRvBV8kn4LD4kkuzLTV3z6fuSCa1tFl0dBzrPfWtrv/o6KKN351hjtjn9xm7c1oflGOe8yIRCC8CWrAZVBbPrP/y38jhW6HT2xiQArhWc5LE+qU+/R5pYNfHU2+e5FLQx0EC9QlSBa5EK0Y7pt5zqpB+Ko56S2yb6pX3C6SGiYSl8FqgbKruployXkf/EfZM0XDPVpA6Bd9kbbD08JTiKd8TGhAS+GZFBLERQbqofSivjbTM2ArKUkZZPCO0gtI76Dqx+XDiEbrR/p2WNQBRN4q22WCMmumAYGWoQO1bZ33M/HHDhqXonRaQ2jO3xMwzBtGo5djGj4yuwIeGKLGaL+xj5EXn83trZYaXyHZyBbtr1P9dmuwGz+hLyOHOUldpJ+5xtxMP5Osll//vt31AtW707Ymizv0vgEQ0Y+jsDXsHWskULC7cn1lPibqNSR8m7J27h3q0ahEvRoH7p243+psZxdRM+fYFKmRIWEkZx7VsBoLAT79uSwSux3ufs
 B96TCqmz
 Enk4DXJKpkHYBmnZs2geCadYZF7ClbtRiTlwAO5EzWGgmcNcHJTxoQP33s2ZIaNrDlliPURXvxgZGzaPKbaISrVqj0si31+HUMdqNfzFC1BbqyUy0ya/qGjFElVI5UMHsVSIwORqaLqpMbWUuJj3Zk6ssgj+jIrG01KygF+Infe5T8/kIoCmi6mGt2zfM6er/3W0r5atKxaQW0iAoIDr+vhzmpb8scEmcyDySX/z6MM5DuizXxNE7CBWMUhmNxgJbNOcQ4+4k+8jd0KFDkAVdw+MAo4bE0D0o0WSDkPGkQ34Cb4yomMl+UYIjtXeji6uP4j3rjfNnpO7J5pD4FBDzYq4oGLSer5U5dLyvwx3P39JkND7j4sDarS2TayAGE6VFpFe2078v1nNJv2C3mz6vAfQv36br7AvehSNZtumt7K0ZyT3+z1jqggL9DONCjq92DCRjT4AErQ4SgTcDZxWbe9PsnGDjqewBym9DpnxxKUD9cWs14zrUnACOArxuLkmLZeaOKVDnpEtBX/Gw3Znu44vqGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 6 May 2026 22:13:58 +0100
David Laight <david.laight.linux@gmail.com> wrote:

...
> Try compiling it :-)

Ignore me...

