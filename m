Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E96606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=MDPgQs+4
Received: by kanga.kvack.org (Postfix)
	id 07C7F6B05B8; Mon, 23 Nov 2026 06:44:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053C26B05B9; Mon, 23 Nov 2026 06:44:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84146B05BA; Mon, 23 Nov 2026 06:44:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDC746B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:44:14 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B174C087F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:44:14 +0000 (UTC)
X-FDA: 85466200428.26.5E97598
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5652B40003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:44:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=MDPgQs+4;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.177 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434252;
	b=oViYKUr47lSroo6Q8Yj+RjFDiOiPwTp5G6GXPRIzToH+H/Wcp4AyvkO1FDLh+DjWLP3rgO
	/ldwGlPRaZcryvb9uY/tg7BjSjCUYjkDLucgl3RYuS448KPae9BBfRNl8eGG9vR5CQFROM
	fNDFhb5RL4zxS2FLOl9ZG7sXu8FzQWM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZG6dMH9M1xr5BizxPYw0XWI2A1la2OQ55Ivi+00UZBs=;
	b=t7UELDaT/qmRMtyiZk4QxvAtZ4E5oYfaLjZ+jeswVXSqhUf6orWPjAjGwhSm1UMPg8c2X9
	nzoZLKnoY1jRLf4e99+I5CW4ZvhGIia1jsLCFzeqY3Y8SbnF2ct3FnqckgWAb8xO0O69lg
	GbInc7MlKvJBXcQ4mfWQoSrCu/E3O1g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=MDPgQs+4;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.177 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3869b68caecso4067894eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1795434251; x=1796039051; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZG6dMH9M1xr5BizxPYw0XWI2A1la2OQ55Ivi+00UZBs=;
        b=MDPgQs+4DTG5Gh1e6GV+SPFXE8bFaL4Fm7rdx2AZUL/gwRrzDR1z2skni5ryKYER7m
         cbi+Jugs+fvjJuST12rJIdlQx5y4LSQogUZnJfj90YxpzQ9c4NXL8JY7f+wfxE4dQpVa
         ghqEagoPxxrJmVBmM+/cRB2wsUCzpOJwvdAsAVbohCNri1clTNZpzMQoZsjZ/sHhuUEc
         CR937X3F5vhijBUJwN9Kr3SuWxes7hTyvjpYeMgzjQzDqGCRS3fyRVHf+w7DuSiUjI1E
         rC8YsZLYVTP9BuOUPjkvStX8n59tDRwSY1gHAOH9z3VhDEbhy5RodzQ0sqxQ6+vsXWui
         5Y4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434251; x=1796039051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZG6dMH9M1xr5BizxPYw0XWI2A1la2OQ55Ivi+00UZBs=;
        b=FlGLZ86HhYDOl/cQoNf3YQx6Zpnz6pqy7rxmftWgicS4QwWpSyoo7eLINaa6NOmJsB
         9SrHP+hsBcLk3IAZT2DhC3tAWsc7IXdM7jYcMVcy5sjt9ODRooFtH0k8AJiNgr1krPkY
         pd5zwydMasVY2t8EzyCInmOF1Tn4MegiUNWV6lVzOz39FmGkRxiCRO5o+WNd2hj9E41A
         V0QiVOCtPS5+mE7rCsYixPvdS1wR1w5dQ+d2RNPv5YbXeWtesmW3+A90eI/PXdHki+WM
         chJxv3sJ7G2fgLJZ+vikxL2loWoIR9GSlFWZNxs3dkxF330vLJ6fg36NKnUiz5WoodGZ
         u4YQ==
X-Forwarded-Encrypted: i=1; AL+hErHlWf09OWBx7BHFparDsiv/Z8hvtaa1QB5qDVCAH042/2N0e671wQS2Icx8s68BAnxMshkAjgjymQ==@kvack.org
X-Gm-Message-State: APuU4Z/4WeiLnkIikANTlZJMsd15Oabav5TlkuMNrewCgZNhp8rvo75j
	sdJGiCba3MOHgriU3DFiRhyFpgaD9MsumE/Ri47VoSLEMfSfZhWHx6+h8gTDOj/VkWG5
X-Gm-Gg: AZFdTZcWgha52390sVVQ3mqm5SrdWkrby8uRVE1zR5Q0/Bv0lk2C0X43cAecsi0Oiv2
	03RU/14Ka1nX0eI0l4Bq3RCGH0XT8m0QU1Ke0Nn+F3xVcqPGmHYMWVGXIY02DyHjnbaJf3BLbR3
	nPuCdZUkEQz6HODM7oym56O9tzOrxv7N5inpqb4q3DWmNTxskhGQOelZzmj4nECiI39ETl/gmDS
	DpfR+LcnSzONE/2/mQr1t5V1fdv/cxcVl6ZWc2PUJA5evysugOEAyc5waJJZ3qX6NkuQO/1cnlQ
	A/P0AJtmdZHnAAwENu6UtvJKduMiWNLalDhSwWpvdQdq5Y6jDtfNBgDV8dq1oRlItnenN5unK50
	l2OZAYvJ5ABOVd2PY0SC2Kb4zLN0VaPj4crC7X0cjDg9Zqih78Z+XDf+hrMs1Nu//XL8BK8is8r
	M4XDVNncaqmfutbLJ0r3ZaiyQbr53N2bN4vTXfbkY9VePAMrzYnckjmxmPOObsiuc9YlnBSNBKu
	cvtx47bNj1vIxCpnbc0Z0z7/K5caLeF5PdLxlMIUg5JJoBUv0l163zCI3iD0sNS23pCOZ6BJoB7
	8UX70RRWQdZNxS24BZFM1TbTsat3BFkS55dP58mHjNRF6Nyi5PMH19toWJgO1By/dAQMH94BX+o
	7fDYQ2V6FnRDWJdYpxlzCWZjx+q8dNWMkib+bUhbZtjNdw7KTKuh5Rw==
X-Received: by 2002:a05:7301:6188:10b0:386:9ba8:2864 with SMTP id 5a478bee46e88-3869ba82acfmr7077586eec.0.1795434250637;
        Mon, 23 Nov 2026 03:44:10 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:14e:94e0:654e:d7ff:13d2:447d])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd40c5sm41943583eec.10.2026.11.23.03.43.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:44:10 -0800 (PST)
From: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>
To: bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Cc: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Morris <jmorris@namei.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	Ketan Bhardwaj <ketan@armoriq.io>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH v4 1/6] docs: security: Describe the Kernel Assurance Plane design
Date: Mon, 23 Nov 2026 17:13:03 +0530
Message-ID: <20261123114308.8103-2-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123114308.8103-1-harisudhan@armoriq.io>
References: <20261123114308.8103-1-harisudhan@armoriq.io>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5652B40003
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6g75fdcsyao9fgneojkpjm884xpjtryk
X-HE-Tag: 1795434252-857304
X-HE-Meta: U2FsdGVkX1++dYOEKpIIP1skK2yfaPJpfMAgJb4LmBEMKijlhROntGwkCAeEg2ruG9YR0Yh6QRJvfRUx7XpDheS9QlaeHSAotajNZ/B9xlzcPuXd+SqA8bpRQocebarOplmvjU8H3IycuKoRJTgmZkSLCcNj/zJd2ni8Fl+sIjzKSDgY1A7DMM8tApqunXXyP2HIdGkRlN8NytwCj3yXjJ6wzH2dCcA/1q+afg+Jjh+qiMaDM19z0jbDLOOwPuEg5AG5W7B4UfJR7g7twTds9JNc4mmhiZK6y/x33FqYuJgtu1U6OYqtOXlqOErseOdqTyQ1Mb4D29weM2Q3X49ylEpSJ3jwO1jyQAJt3Rui4A4lgd824GQr9r1mh+qWcXTfBH8zeU9IC2JKrrv2JfSvvi6Mzj+fvwJyqX3KiZDBbFK3lvoqGMKFenfsbqMN2onBIaGQUrb769+w9BkjMBDpNaz2iaGOHIpOfx44im0xICpN9yy/Mb8ViO6omo6NnQeOrDtpq7Ish8SE4VIel+Cjfuf9fCYSfBcsAGZwZxlwEbI8aPYJvBNf+u+9tHHxVwNVG4uxMwyqvD84RBPew9q+vD9b2XXLrPpFtV0cHEH3R/HEwWQkT2vOHL4FmbDStU8tNsU6Blpie29G/wSskmGL+m3pXyQhe6HfJ1IgaB8W8D1WS7ahWB3UozJntm2nMUSZRN+3LUO48s3vt7Mqd4NLRaHK8YTvVp6AEfvvjqSQbx0dZ9QHfV5XRynWTBbJll/hD7Ni4WQt0giqUjFh1ck4SVyndU7kD0iTnvV6TR0kSOYoypZKX/FYVplmKmkgOYPPaEC9tPP0ILG+cLtT3pNMH3+1zE2liqwPATYb6M48tpCr5mEoqyISrMvMwISjfNHXyEyJ4HsK1unP1fJeRvUP7pggHCEwOPJbofuNkYB+WAX474Jm59c4VNNHa7KZUl1V2SLpq4wzScUp637QIGD
 2VSqapl3
 AY5PKFMs4Rl300SafjWuMSTjSrqPEhS3yMf1A/pn7RfsnuikodGIunTNlkpvYItPDr8VBMeKDJ92bdMl2/D9DtZJIoJ3vYJ6BFwUwafbtLTAt5zPhwy4ROjnKDWj6qVFluDwJps0PRo2XMedaHSo7dZAly7OFcS4IFLb6sg6ydHwZEXh/Z4VkP1QWZWXVbI8zvGBg+kszzCR/vcBOHUynSvpl0jIWUYzQhEhbmGyad23Jes8n+9BtbLcdS3I3c5Gjcgk7sqUGtKPDhx2agQPeRmEEhP2j36l6pAzDpai/sK0P9sVpromIr1v2zAh/yBvNCqzqNetFWAm+QKInAjrW2OZMljxxQIrKbszZ088hPNbrOHJAJZFkO/KgxDLIubTok1PTqeiutpFZFrscQ7S69DwL8TX2tQl+SZ6hq/EBBEncKB130Y6mQW2E2YdyWsTpFgW7Xdd43+K6uB2VzWEERd18BqgKJaHRyyFectxUCBuMc5ONy+lEYjZqjGDUpJZqlmh/Qq7cNEx3661kRKpll3IxpeO0ghRkGVGKpWOtiAuI1J/1sQkY7D88yVnfYY1a9qs1FrHItB/Hbpjp6wmuVyYfALiylfdfZUGyttjXmL81rFmcHILMGBB5tcjesaTxQ1ySw/Z9SLYi0ww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Describe the Kernel Assurance Plane (KAP) design.

Agents and other long-running tasks act on behalf of an objective that a
user approved. Linux decides whether a task may perform an operation,
but not whether the operation still belongs to that objective. Seccomp,
LSM profiles, namespaces and cgroups cannot hold several objectives apart
inside one environment, or revoke one objective's authority while its
task runs.

KAP introduces objective-scoped authority as a kernel subsystem. The
document covers Intent Lineage Groups, the authority model and the
control plane under /sys/kernel/security/kap, where igroups are created
with mkdir as cgroups are. For each design decision it lists the
alternatives considered, and it ends with the questions on which
maintainer feedback is wanted.

Assisted-by: Claude
Co-developed-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
---
 Documentation/ABI/testing/securityfs-kap | 111 ++++++++
 Documentation/security/index.rst         |   1 +
 Documentation/security/kap.rst           | 341 +++++++++++++++++++++++
 3 files changed, 453 insertions(+)
 create mode 100644 Documentation/ABI/testing/securityfs-kap
 create mode 100644 Documentation/security/kap.rst

diff --git a/Documentation/ABI/testing/securityfs-kap b/Documentation/ABI/testing/securityfs-kap
new file mode 100644
index 000000000..066de0b9d
--- /dev/null
+++ b/Documentation/ABI/testing/securityfs-kap
@@ -0,0 +1,111 @@
+What:		/sys/kernel/security/kap/
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Kernel Assurance Plane control directory in securityfs.
+		The ABI is experimental and intended for RFC review.
+
+What:		/sys/kernel/security/kap/kap.default
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write "open" or "closed". When closed, a task
+		outside the initial PID namespace that is bound to no igroup
+		cannot start a program.
+
+What:		/sys/kernel/security/kap/igroups/
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Directory of Intent Lineage Groups. Create an igroup with
+		mkdir, as a cgroup is created.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.install
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Write the lineage root, authority epoch, optional expiry and
+		transition, and the authority as one key=value document in a
+		single write. The fields commit together or not at all.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.procs
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Write a pid to bind that process, with all of its threads,
+		to the igroup. Reads return the pids written.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.lineage_root
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write the opaque lineage root for the igroup.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.authority_epoch
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write the current authority epoch. A lower value is
+		refused, and a write clears revoked mode. Bound tasks whose
+		recorded epoch is stale fail KAP checks closed.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.authority
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write the authority document for the igroup, in a
+		strict subset of JSON, with a "predicates" array, each predicate having a
+		"kind" and "allow" and "deny" arrays of patterns. The
+		Kernel Assurance Plane design document lists the kinds and
+		how patterns match.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.expires_at
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write the authority expiry in seconds since the Unix
+		epoch, or 0 for none. An expiry already in the past is
+		refused. Once it passes, every check for the igroup fails
+		closed.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.transition
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Write a transition record whose sequence number is higher
+		than the last one, to prevent replay. Reads return the last
+		sequence number.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.mode
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write igroup mode. Supported values are "enforce" and
+		"revoked". A revoked igroup refuses every operation.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.events
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read recent KAP decisions as JSON lines with the fields
+		ts_ns, igroup, decision, operation, target, reason, epoch,
+		root and pid.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.igfd
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read the igroup's name, epoch and lineage root on one line.
diff --git a/Documentation/security/index.rst b/Documentation/security/index.rst
index 00650dcf3..937193b13 100644
--- a/Documentation/security/index.rst
+++ b/Documentation/security/index.rst
@@ -18,6 +18,7 @@ Security Documentation
    siphash
    tpm/index
    digsig
+   kap
    landlock
    secrets/index
    ipe
diff --git a/Documentation/security/kap.rst b/Documentation/security/kap.rst
new file mode 100644
index 000000000..3dbc92b80
--- /dev/null
+++ b/Documentation/security/kap.rst
@@ -0,0 +1,341 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
+Kernel Assurance Plane
+======================
+
+Kernel Assurance Plane (KAP) introduces an objective-scoped authority context as
+a kernel object. Intent Lineage Groups (igroups) are that object: an externally
+managed authority whose lifetime is tied to an objective rather than to a
+process, a thread group or a sandbox, that a trusted controller can update or
+revoke while unmodified worker tasks keep running.
+
+This document describes the design for review. It lists the alternatives that
+were considered for each decision and the questions on which maintainer feedback
+is wanted. The central question is in `Authority lifecycle versus enforcement
+mechanism`_: whether the novel part below should be a small authority-lifecycle
+facility that composes with Landlock and existing LSM hooks for the actual
+mediation, rather than a self-contained LSM that carries its own.
+
+What this is and is not
+=======================
+
+The distinctive part of KAP is not path or syscall mediation. Landlock already
+restricts a task's access to the filesystem and to a few other operations, often
+more completely than the checks here, and seccomp already filters syscalls. KAP
+does not try to replace or improve on either.
+
+What Linux does not provide today is an authority context with these four
+properties together:
+
+* It is **externally managed**. A trusted controller, not the task itself,
+  installs and changes it. This is unlike Landlock and seccomp, where a task
+  restricts itself and cannot be restricted further from outside once running.
+* Its **lifetime is tied to an objective**, not to a process, a thread group or
+  a sandbox. Several objectives can run in one environment, each held to its own
+  authority.
+* It can be **updated or revoked in place** by the controller, and the change
+  takes effect at the next operation of an already running task, without that
+  task cooperating and without killing it.
+* It is **inherited** across fork, exec and setns, so the authority follows the
+  work rather than a particular executable or label.
+
+Everything else in this RFC, the set of checked operations and how each is
+matched, exists to make that authority context enforceable. Those checks overlap
+with Landlock and with existing hooks, and the open question below is whether to
+keep them in KAP or delegate them.
+
+A motivating example
+====================
+
+Two objectives, O1 and O2, run as separate worker tasks in one environment. Both
+start with authority to read ``/workspace`` and ``/package-cache`` and to reach
+the package registry. They are bound to two igroups.
+
+O1 finishes its first stage. The controller installs a narrower authority
+generation for O1: no package cache, no network. It installs it at O1's current
+epoch, so the worker that is already bound stays current. O2's igroup is
+untouched.
+
+From its next check, the already running O1 worker is held to the narrower
+authority. It cannot reach the cache or the network even though it could a
+moment ago, it was not asked to drop anything, it was not restarted, and O2 is
+unaffected. To revoke O1 instead, the controller raises O1's epoch; the bound
+worker's epoch no longer matches the igroup's and its next check fails closed.
+
+This is the behaviour that a self-restriction model cannot express. Landlock and
+seccomp restrict the calling thread and its future children at the point the
+thread asks; they offer no way for an outside controller to narrow or revoke the
+authority of a task that is already running, per objective, while a second
+objective beside it is left alone. That per-objective, externally revocable
+lifecycle is what KAP adds.
+
+Model
+=====
+
+``igroup``
+  Intent Lineage Group, the unit KAP enforces. An igroup owns an authority
+  snapshot, a lineage root, the current epoch, an optional expiry, a transition
+  sequence, its bound tasks and an event log. A process is bound by writing its
+  pid to the igroup, which binds all of its threads. Children inherit the
+  binding, and it is kept across exec and setns.
+
+``authority snapshot``
+  The predicate set for one igroup epoch. A deny wins over an allow, and an
+  operation that no predicate allows is refused. The snapshot is compiled once
+  when it is installed.
+
+  The snapshot is the model's authority representation; its on-the-wire form is
+  not. In this RFC that form is a document in a strict subset of JSON, used only
+  because it is easy to produce from the prototype runtime::
+
+    {"predicates":[{"kind":"file","allow":["/srv/work"],"deny":["/srv/work/keys"]},
+                   {"kind":"exec","allow":["/usr/bin/*"],"deny":[]}]}
+
+  The JSON subset is a prototype representation, not part of the model. Any
+  userspace policy format is translated to the snapshot in userspace, before
+  install. The kernel-facing questions are the representation's bounds, its
+  validation, and atomic install and update, not accommodating a configuration
+  language. A bounded, versioned binary form, or reuse of an existing ruleset
+  format such as Landlock's, is the intended direction and is question 4 under
+  `Questions for maintainers`_.
+
+  The predicate kinds, and the limits of each as currently implemented:
+
+  * ``exec``, ``file``: a path, matched against the path and everything below
+    it. File predicates also govern rename, link, unlink, mkdir, rmdir, mknod,
+    symlink and truncate, checked as the parent directory plus the name, so a
+    file cannot be moved into a denied path. A program is allowed by the path it
+    resolves to and refused by a deny on that path or on the name it was started
+    with. This is ordinary path mediation and overlaps Landlock.
+  * ``net``: connect() only, matched as ``address:port`` such as
+    ``192.0.2.1:443``, or ``family:N`` for a family other than IPv4 and IPv6. A
+    connect with ``AF_UNSPEC`` is not checked; ``AF_UNIX`` is checked as
+    ``ipc``. bind(), listen() and already connected or accepted sockets are not
+    covered. This is not a service-side network policy.
+  * ``ipc``: Unix domain checks are coarse: ``unix:stream_connect`` and
+    ``unix:may_send`` do not yet identify the endpoint. For a pathname socket
+    the resolved endpoint is the right target and is not yet used; an abstract
+    socket needs its own semantics. ``sysv:flag=N`` is only the flag passed to
+    ipc_permission() and does not identify the object, so this is not SysV IPC
+    confinement.
+  * ``descriptor``: a file_receive check on the resolved path of a file received
+    over a Unix socket. It is not a descriptor lifecycle model; using a
+    descriptor already held, and accessing a mapping already established, are
+    separate and are not covered by this kind.
+  * ``procfs``: path-based matching under ``/proc`` with the caller's own pid
+    normalised to ``/proc/self``. It is not a general procfs security model.
+  * ``execmem``: the path of the mapped file, or ``anonymous``.
+  * ``cred``: ``uid=U`` and the other id fields, ``groups`` or ``capset``.
+  * ``namespace``: ``TYPE:OPERATION`` for clone, unshare and setns. See
+    question 5 under `Questions for maintainers`_ on using existing hooks for
+    these instead.
+  * ``ptrace``: ``same-igroup``, ``igroup=NAME`` or ``unconfined``.
+  * ``bpf``: ``cmd=N``, with ``map_type=N`` or ``prog_type=N``.
+  * ``io_uring``: ``override_creds``, ``sqpoll`` and ``uring_cmd`` only. These
+    three checks are not a blanket disable of io_uring and do not carry the
+    submitting task's authority onto every asynchronous operation.
+
+``epoch``
+  Monotonic authority generation, stamped on a task when it is bound. Installing
+  a new authority at the same epoch re-points a bound task at it without
+  interrupting the task. Raising the epoch past what a bound task carries makes
+  its every check fail closed until it is bound again, which is how an authority
+  is revoked.
+
+``lineage root``
+  An opaque reference supplied by userspace that ties the installed authority to
+  a committed execution lineage. The kernel stores it and reports it in events;
+  it does not interpret or verify it in this version. Whether a refined snapshot
+  is a valid narrowing of its predecessor is a trusted-userspace responsibility,
+  not a kernel check.
+
+Deployment and privilege model
+==============================
+
+KAP is meant for a supervised agent runtime, not for an unprivileged application
+that installs its own sandbox. The task running under an igroup is not the
+authority for what that igroup may do; the fact that a user started the work is
+not itself a grant.
+
+A trusted, privileged runtime combines the task, its workspace, the tool
+contracts, credential bindings, administrator policy and any approvals into the
+compiled snapshot, installs it, binds the worker, and then runs the worker
+unprivileged. Writes to the control plane are authorised against the initial
+user namespace. The worker cannot widen its own authority; it can only have it
+narrowed or revoked from outside.
+
+Control plane
+=============
+
+KAP state lives under ``/sys/kernel/security/kap``::
+
+  /sys/kernel/security/kap/
+    kap.default
+    igroups/            created with mkdir, as cgroups are
+      <igroup>/
+        kap.install
+        kap.procs
+        kap.lineage_root
+        kap.authority_epoch
+        kap.authority
+        kap.expires_at
+        kap.transition
+        kap.mode
+        kap.events
+        kap.igfd
+
+``kap.default``
+  ``open`` (the default) or ``closed``. When closed, a task outside the initial
+  PID namespace that is bound to no igroup cannot start a program, so a bind
+  that failed cannot leave a workload running without authority.
+
+``kap.install``
+  Write the lineage root, epoch, optional expiry and transition, and the
+  authority as one ``key=value`` document in a single write. They commit
+  together or not at all.
+
+``kap.procs``
+  Write a pid to bind that process, with all of its threads, to the igroup.
+  Reads return the pids written.
+
+``kap.lineage_root``, ``kap.authority``
+  Read or write the lineage root or the authority document. A write to
+  ``kap.authority`` is compiled before it replaces the current authority; a
+  document that does not compile leaves it unchanged.
+
+``kap.authority_epoch``, ``kap.expires_at``
+  Read or write the epoch, or the expiry in seconds since the Unix epoch (0 for
+  none). A lower epoch, or an expiry already in the past, is refused. Raising
+  the epoch past what a bound task carries fails that task closed from its next
+  check. Writing an epoch, or installing authority, also clears revoked mode.
+
+``kap.transition``
+  Write a transition record whose sequence number is higher than the last one.
+  Reads return the last sequence number.
+
+``kap.mode``
+  ``enforce`` or ``revoked``. A revoked igroup refuses every operation.
+
+``kap.events``
+  Read recent decisions as JSON lines with the fields ``ts_ns``, ``igroup``,
+  ``decision``, ``operation``, ``target``, ``reason``, ``epoch``, ``root``
+  (the lineage root) and ``pid``.
+
+``kap.igfd``
+  Read the igroup's name, epoch and lineage root on one line. The name is
+  reserved for future igroup file descriptors.
+
+Design decisions
+================
+
+Authority lifecycle versus enforcement mechanism
+------------------------------------------------
+
+This is the decision we most want feedback on, because it shapes the rest.
+
+The current series is a self-contained LSM: it holds the igroup authority
+lifecycle and also performs the operation mediation at existing LSM hooks. Most
+of that mediation, path access in particular, overlaps with Landlock and could
+be expressed with it.
+
+The alternative is to keep only the novel part in KAP, the externally managed,
+per-objective, revocable authority lifecycle with binding and inheritance, and
+to compose it with Landlock and existing hooks for the actual enforcement, so
+that an igroup's current generation drives a Landlock ruleset and other existing
+checks rather than a KAP-private predicate engine. That is a smaller and more
+upstreamable facility, but a larger change from this code.
+
+We implemented the self-contained form first because it is what runs today and
+makes the model concrete. We would rather present the authority-lifecycle
+facility that composes with existing enforcement if the subsystem agrees that is
+the right shape. Question 1 under `Questions for maintainers`_ asks exactly this.
+
+Where the control plane lives
+-----------------------------
+
+Igroups are created and destroyed by userspace, so the control plane needs
+directories that userspace can create. securityfs does not allow userspace
+mkdir.
+
+Considered:
+
+* A dedicated filesystem mounted at ``/sys/fs/kap``, the prototype's first
+  interface. It works, but puts security state outside securityfs, where the
+  other LSMs keep theirs.
+* securityfs with control files, for example writing a name to a ``create`` file
+  to make an igroup. This keeps everything in securityfs but replaces mkdir and
+  rmdir with a private protocol that every tool has to learn.
+
+Chosen: a small internal filesystem that the kernel mounts itself and links
+under securityfs, the approach AppArmor uses for policy namespaces
+(``apparmorfs``, linked as ``/sys/kernel/security/apparmor/policy``). Users only
+see paths under securityfs, and an igroup is created with mkdir, the way a
+cgroup is.
+
+Igroups rather than a cgroup controller
+---------------------------------------
+
+Considered: making KAP a cgroup controller, since igroups are created like
+cgroups and follow the process tree.
+
+Chosen: a separate hierarchy. Linux can of course group tasks, including across
+setns; the point is not that it cannot. It is that we want the authority
+lifecycle to be independent of the resource hierarchy. A container usually
+places all of its tasks in one cgroup, while several objectives can run inside
+it, each needing its own authority and its own independent update and
+revocation. Tying authority to resource partitioning would prevent that.
+
+An authority-lifecycle object rather than BPF LSM programs
+----------------------------------------------------------
+
+Considered: carrying the model as BPF LSM programs.
+
+A BPF LSM can enforce at security hooks, and a BPF implementation could carry
+parts of this, the per-operation checks in particular. So the question is not
+which mechanism enforces, but which authority-lifecycle semantics should be a
+shared, in-tree contract: how an authority object is created, attached to a
+task, inherited across fork, exec and setns, updated to a new generation, and
+revoked, with those transitions taking effect for already running tasks. Those
+semantics are kernel object state that we think belongs in one auditable place
+rather than being re-implemented per deployment. Which mechanism then performs
+the mediation is the subject of the lifecycle-versus-enforcement decision above.
+
+The kernel enforces the snapshot, not a policy language
+-------------------------------------------------------
+
+Considered: parsing a policy language in the kernel.
+
+Chosen: the kernel accepts only a compiled predicate snapshot. From the
+kernel's point of view that installed snapshot is the policy. Objective
+interpretation, authorization decisions and validation of the upstream
+artifacts stay in privileged userspace; the kernel enforces the installed
+snapshot and the execution binding, and compiles the snapshot into per-kind
+pattern sets once at install time.
+
+Questions for maintainers
+=========================
+
+1. Should this be a minimal authority-lifecycle facility (bind and inheritance,
+   atomic generation update, revocation, with lifecycle kept separate from any
+   sandbox implementation) that composes with Landlock and existing hooks for
+   enforcement, rather than a self-contained LSM with its own mediation? See
+   `Authority lifecycle versus enforcement mechanism`_.
+2. Is an internal filesystem linked under securityfs, as AppArmor does,
+   acceptable for a control plane that needs userspace mkdir?
+3. Should igroup removal follow cgroups, with rmdir allowed once no task is
+   bound?
+4. The predicate snapshot's wire form is a JSON subset and experimental. Is a
+   bounded, versioned binary format preferred, or reuse of an existing ruleset
+   format such as Landlock's?
+5. For namespace transitions through unshare, clone and setns, this series calls
+   KAP directly. If the target tree has, or would accept, LSM hooks for those
+   transitions, we would use them instead of calling KAP directly. Which
+   existing or proposed hooks should we build on?
+6. The LSM ID is provisional and should be confirmed.
+
+RFC status
+==========
+
+This interface is experimental. The RFC is intended to make the authority and
+lineage model reviewable, not to freeze the userspace ABI.
-- 
2.43.0


