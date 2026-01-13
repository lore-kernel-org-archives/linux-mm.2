Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF826D0C85F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 11:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F566B0089; Tue, 13 Jan 2026 06:46:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420DC6B008A; Tue, 13 Jan 2026 06:46:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316086B008C; Tue, 13 Jan 2026 06:46:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 205906B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:46:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A28851402CD
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:46:47 +0000 (UTC)
X-FDA: 84326763654.21.3F29747
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf26.hostedemail.com (Postfix) with ESMTP id 57D9A140006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:46:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bGK798vu;
	spf=pass (imf26.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768304805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d85txJdof5wjo71Nb7SGfL6iakONr6lxOxxOTz4d06A=;
	b=MQ4v+S+qmcHYxgDVedo1V1Nhh7RfLB4Nth0Kfi0obnHu9gArq4RppWzv9Uv/rErayNQAeD
	ELY7kUVs3mwUsBUsVArlb5rKBmXlneIMh3PAwhW0HVDkQXmsVzkhOLhOpEsUQL6i1mlJtO
	8nY3a04u4zF3FdVdkJK2XCdyySOXShU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bGK798vu;
	spf=pass (imf26.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768304805; a=rsa-sha256;
	cv=none;
	b=8NZpenl74qLQOZ9plHNF5cIbA7/3vv+f9W4iE43yjWbuslpYHJp2mYddw3ek7peSh3JLV6
	i1HuJTNF+bdSyaE9sFegaoToy96Nhr1TYoNhLvazx8IH1acAJBN4ntBh03vJGUrXvYd/o5
	no1/FHwyF/oBuNLqZDc/my7tY8n9zXs=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-47d59da3d81so28154245e9.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768304804; x=1768909604; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d85txJdof5wjo71Nb7SGfL6iakONr6lxOxxOTz4d06A=;
        b=bGK798vuzGKJYf3PpbFI8cX7fz8Jm+qEdnMj3uigA8dVLYDshnjJRiNiCrkYtJvMz1
         EBXnuAAYFhyzDtS0Gv1efupMXBWBdTYsetZ0wPshKQjlRuoAOdCx5COrmr9cF9c+KfEZ
         MjUBrvxrXGUCxm3omiSUN5kYRxOp23Q/2ozPWfyxU6OX3KqBoaJv7cWLr6GkZH/QeDdv
         SBoQd0rqLOje808TjIDHLTlsXu7OBUSzjQ99Rir8RnP+19shSjGXO7FNyhN51kDM71Cf
         7+2K+oI++NEE7k/GH51AfOCTcNsT+99SkuMAGHnXOF+e37kdH6ru/lJ+gI6pZykhsav1
         45zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768304804; x=1768909604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d85txJdof5wjo71Nb7SGfL6iakONr6lxOxxOTz4d06A=;
        b=WWBat6oVgoochFM+zdZt8t+KsXAXOa8gZj9Xiblbs9XGaiaMxl9Hxh3JhOizefXSI6
         HvZ4nq4qyYv8pNw26b1wGGedO5Qt8Y9dLRHD6S9fiR1b0En1y3k7LsUB9MxE9G6maMyK
         vMfdA9E42K1T7JcH9EGH+fwPUSjMTJUkBnXz1xdsHkV9JZD4hacdZwfpmX7ObDpPIWwJ
         +P2juTHjqQhvx9VZaP2gujc2SHuCbNoSfpj5xlyQPPK2Vryv4rDdwihn0DsF65jJaQRh
         ApJZ8OYmNhhw3bgY4sil7RyGK7JOrsYEjkEnFc2FUPcA7GKjG+S+mhx/cw4HKgtwXbmj
         jL+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUeX+B4eUJHyktZwPvmhlNw7vozLAVfE3eA7j/iCT0tbJDG/XYKEUc5vw39kROkMqUnlO6g/aRKgQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9+MDs64I3CkG4D2hja4BBYk4mL1q8BeetxjuxqO6dO2/gForU
	d6qo28JX2+olufCP4woEfrm3q3tyySr1IgBxvzDWRDWlMvFQ8JAIx8se+J0x7/h8EU0=
X-Gm-Gg: AY/fxX6uaB9VpN/CeWeXkzsJrTJwDpkaNOUxhyd2hbDAzoqykpwve3qKXf93u+q71UD
	kBniUwI2pgmyAHP7P40Ey6N7TUIh48kUyXvAfbvoEhAMBUjQ2KBRUJ2Eopt7JTnWBAGuLNodRSO
	Hwtzna80rV0yaCUEUL4XyaCyQKewJ4KEaQ+7EOVM2vFRN2tIOpJ9ZQY42L5hhxVoFeRMQt6Q8Eo
	pJM7H8HcIBpulqTRmemz1osbanAeZPQkEOVAME+sBIWSICPT+RrBTeRgNxj9TORCL4O3jXfO5Vw
	EGqB733hJAu/ripmoPYJC00v5Xl+l+2i1eVYe29rgYTK5c13GRgQZkUW8AFQXlB0q0ef4I/RBhO
	vHGirKnPBWif6TN02cbIwCEGauTF1EAKidYX7r6ZGtn6b8g+j4vpGFZ68tgMj9hGBoQmp0n5wbl
	KpFHasqwciBUpoM6bXwRjhQ0AW
X-Google-Smtp-Source: AGHT+IE8lj9FXAKsI9HXvuYhEyQ9TgnPxIb5OezkOJejVnghUIBNYs6ePvqZ/bK3Amw23Qi9we5IDg==
X-Received: by 2002:a05:600c:4f87:b0:477:9890:9ab8 with SMTP id 5b1f17b1804b1-47ed7bfd9bcmr28168805e9.3.1768304803742;
        Tue, 13 Jan 2026 03:46:43 -0800 (PST)
Received: from linux ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f6953fasm391850225e9.5.2026.01.13.03.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 03:46:43 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/3] Replace wq users and add WQ_PERCPU to alloc_workqueue() users
Date: Tue, 13 Jan 2026 12:46:27 +0100
Message-ID: <20260113114630.152942-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 57D9A140006
X-Stat-Signature: 8cf11k6n5wymkigxqqeohxxdzxno4zbb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768304805-208511
X-HE-Meta: U2FsdGVkX18mpsysGOP5N7BDB7qj/Oc5b9kvRrB+/QO2vGoTqvEulXnIEVYE+TBVXHv57OmDL18mZcSNZbsLqbekvIyx7IArpKdbl9S5S4ptADciM9cEoF9PG6IToPrd8LEyBUwcE4qP92rnClaopR/h0Ryd4LMlDaS/iyHuu/RFJNarbxNUkzawp/BglzurmeuHt+z5WqAOim9ku3fReylrrKaRGr946j57E8C5sFCY4x+JwSDpA6qhDniZOLFNwUpX3NGslKkx1Tq/ezQ9xIDNf3VP+FizMi0f3/qaIaH3PC9U9erY4nWk2A2q/ZT+ecoRSFQ/Fm8IRjL2pyEOdxdE9KWhvAL2X9iggQYPdc0cOvUHiob7fb7R1YLuS8rM/gE2VSVSIsx4SUyq+ZY6QmIJffhzY8S8b6XQk8etOI0RzzTTRKtp8t08vBkC3IDp8rk/1Xa/ui+o8NE9QCsAqSkvgPkGP+RoxLiuK+iIRjTrNNchtGXik8iluEcSzsIbfdUvEo7h8oFq0OWyGy8pDY6X5vHDXzNxGxFwc1PO3LoWQtpEMJqXEMpn4kYX2QlO/+MeQHPANkbbogZsyZRrTyFe42bLCBIQbf05X+4SWO0L49Q8CxiI6ri8sXIXq6lfS/PA+YaHHZxsdQvdcEaGPjh0z+qXepIx4e0RfBP4S/gLWId95A6XFgsE7fZGDVElRUmHc6DOqecJgxySRa855MAcARk2mShB6cZFrLaaG0sg/6ao4RvPYNo/VSqRwpdF+Wow+Wzrg8iXJmc7sj0nRR53SHa0n4zGNxSPFG37ChWo6Ij0JSBH0sMZ5sUo4Prc7BPj9fbBxhBoFPSHsFJC9QrD3nRqmXPl9dfWyuD/Umy1GwgPbK2p3DVXnh7tgCajjCTeGNQslBKSgxzLlni1QUocaH4SZyveLegnPsAv1fgJBCi6XRujENVupxoAbWO6l8TQIaV5CEr5RMGE6Mq
 zJY9EGeO
 m/Ze4N0roL94+GQW7hQTzbFhNdN7KfzTujKsrbqvxa57yp24TS8sfNS+uyVWG5IGh6uEYmJss4r1U298NifY4j0plKVDil3WRMgNQMbL/xMF7ALJtNu8bXJlKpLwaIvzcdyL4R3hECtPmDJrvKHNUwjc9aVL0HvOl+nuozMCxLAvSBfW4K7Ub3uy3JjzxlNiVWhzbFTiJ3XG59DnuCm0O+ZzGvl9Wk9//3RnnnbAxmo0TO6NomTgrwZl1UZZZ33qBqhsQPQQxB+1hHkwdJmkI2QHI6pNiiOTXWojAosufhKev8Jel8YJ/ECzWfXjpywSFy+PM4ituJ0OZKxmSdWfo9JKtNrjtkJS9n22ndo03M5TjFlv76atIK9nleXj3Vr6Aq14ITEIbZypPuqv0VnQ7n1auCNDswr+byMCjtuRCHI5BPbpTDyULfgwpyxcwhizAEhVzIAchIh5f7DnrnzKRZQzJqGJXAPJ9u3GuX7iXResB8wqpck4fFfX3PQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This series continues the effort to refactor the Workqueue API.
No behavior changes are introduced by this series.

=== Recent changes to the WQ API ===

The following, address the recent changes in the Workqueue API:

- commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
- commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The old workqueues will be removed in a future release cycle and
unbound will become the implicit default.

=== Introduced Changes by this series ===

1) [P 1-2] Replace use of system_wq and system_unbound_wq

    Workqueue users converted to the better named new workqueues:

        system_wq -> system_percpu_wq
        system_unbound_wq -> system_dfl_wq

    This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
    removed in the future.

2) [P 3] add WQ_PERCPU to remaining alloc_workqueue() users

    With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
    any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
    must now use WQ_PERCPU.

    WQ_UNBOUND will be removed in future.


For more information:
    https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/


---
Changes in v2:
- commit logs upgraded with a better description
- rebased on 6.19-rc5

Marco Crivellari (3):
  mm: Replace use of system_unbound_wq with system_dfl_wq
  mm: Replace use of system_wq with system_percpu_wq
  mm: add WQ_PERCPU to alloc_workqueue users

 mm/backing-dev.c | 6 +++---
 mm/kfence/core.c | 6 +++---
 mm/memcontrol.c  | 4 ++--
 mm/slub.c        | 4 +++-
 mm/vmstat.c      | 3 ++-
 5 files changed, 13 insertions(+), 10 deletions(-)

-- 
2.52.0


