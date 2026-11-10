Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9306960A3809
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Pl+q/RBw
Received: by kanga.kvack.org (Postfix)
	id A0FA66B05D2; Tue, 10 Nov 2026 15:23:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3EA6B05D3; Tue, 10 Nov 2026 15:23:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8BE6B05D4; Tue, 10 Nov 2026 15:23:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59B206B05D2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:23:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DF49C160A93
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:23:34 +0000 (UTC)
X-FDA: 85420334748.17.AFF9778
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 099A416000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:23:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b="Pl+q/RBw";
	spf=pass (imf08.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.181 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342213;
	b=qls9bY6yHsARwac+L8HlJ542pzUBsM3XOMBOHoXB88N4Q/WDbKsIbQmsmhoJ4kBXKX4Zgo
	nwlUW44OQy1TYrvu3LeFd+0TtI+aoI5ecjM+LOrlE7dGrRBcXtFR4sKkSr9DadSCqgSGL9
	IPNiIf9ASQewz2O79AurZ5Ik/nkladk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b="Pl+q/RBw";
	spf=pass (imf08.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.181 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ofO7AY1iN5lpz+U3M2CbPQkAU3++HEg9/f+SJyXxtko=;
	b=R7NQ+TYKULGuBUaYlMWNPTcFLX93kVgTcZ+f5L1jLlTn+ssw4+qiqJX9KRRbYa4SnoCh7P
	Bx2wawhI3INykXH2mzACXYfEQfjEYccAJPwgHERUb1XRMTDvY2tVqsMX3urxUVdjBAHcSq
	4fzJELg6oZCr5O1DWfNDmBxwVwYXhXI=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-37000e7234bso4641484eec.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1794342212; x=1794947012; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ofO7AY1iN5lpz+U3M2CbPQkAU3++HEg9/f+SJyXxtko=;
        b=Pl+q/RBwWbNa1Us1zIl1B05BLxD0sT0HnMM2kEQN/R6YuEXyPkfDVGQG+ICHTPaXNM
         7O45P7ekCp5OpF/4j6Xu28dRggI9dpZMzTM58M3B0hgAtiba9F/QDudVZrAgpo3cJ/yF
         o46xMAtalMk7I0+vWDQDCH4uz5EDDRv9DcuSfcdVILIUoNaKSOzuOcwn9kaXksTYRW+a
         VBsre0QYa+e+od57JoGNr9qg20SpwL4zXP62jWKPG5Zg531oCeN/i6VQUBpDOg+2enr5
         JOSMaRAYjUyYg0NjQVhPIA1bOkW/x+E386QwpS0ECRQ5uv4jZpffUsUGyvg0Z487s9D1
         9QGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794342212; x=1794947012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ofO7AY1iN5lpz+U3M2CbPQkAU3++HEg9/f+SJyXxtko=;
        b=py9x9aDoHBcd837CjVY4/WLiZTBAYVk8NbcCF+RMT/0h2hnkI1WoYmDflZ9YMFjBWO
         bkT7pmUMMmFqKBMZyrp9OCwQa9GRC2hi48VUwlL/vA9LT66N//cwZAS5msUlZkAKxxSI
         TbWJqEOPHRtk2jEWlEaaPbM5j2PVsJVcbcPuPbV9VZGhXoECk9TWKAAxV3K2LsxVPVx0
         q6r7WxW2Mx18+wqpBfcGmVw4q18KqecIvrXYXGvw1ydL+MBXRTpBoSY/4XLfk4CZPa/I
         l3G3VM5YO2pd0Zdl1hlOFfWwMmCBONyu3hXggHE5K52T/wu6wx705ppS9IRtU8FIvP5v
         50Fw==
X-Forwarded-Encrypted: i=1; AL+hErECtH3solrxp7nvgmRyuUvS9xtz/v1QU+j4awY0G0EvXQ7i11WxlGRymnoosZDshUuG7P+Ycr1Nvg==@kvack.org
X-Gm-Message-State: APuU4Z9UfbiHTZBp123ObUYgxcpmptRFIMlHGZlncnQWXx0pnczc1hBR
	dNa3HvIMI9tzY408C/tWbJZA/cDEaZxTj0Fqsx6JlMYRBw7HPmxFGiNShy7zJ4xO0+XG
X-Gm-Gg: AYBFou29PxS6OVxJlBmKLjy5rkvob5NVEQ5/CmbOmTJH7Q7sCMaefSYduaA9Kh9cWBQ
	wQbuCEzTG64zADxrzv77Oa+N9xoxdM68s2SkrAasHQuN5SZR4ZYRMfEgnP3vH7TLMYIcdloPNMR
	weUOqDQC2SOQ9rxK59gP05YUaqvZHq3qXgQuhe7A/LXZcZoS5x4OWjkltVIobg0k8lgWaOU0wFL
	EBxGNeXOqSNmj4l6/uZ115SSsUViQe0xv3TXdlX+2JnON5beDdaMyhonGX56wR0eokLMATU1qFX
	eNMOAd8ms3cpNQrGcU9kcCGPE+VxX1lmuF1ASsY0KN9QNT8libY4myrCjwBaYGtAm7VGEDjdVI8
	ANJLGRnmAqgppPG5r2dxD6ruEF13oUYvRD/7uWOdLBZGRpbrqBVSZaZrVngJcrqFnIrXFsT+Azg
	b/frS8ZAC6n5+DAg03e6lgzAmiyA4KBurt8NJwAv+E5IoYdtaB2LOylU7CmGuv9/ovu/mDW/Ybv
	qCUbq45GiLynVwgOxgQOM9qgEJSjs3keCwxbgjOXonv0uSCnIngYl19ZlkMDXAKxwvMIHSDKKDA
	h4eTBOTeAJnL6s79A7U6R6TTT4Chhm8fh+G0+ziz4Y0imrj1xT/SVJeBQRTNBOC2sdOvQvBEead
	F6G8oydTbbFCeXyxghS5gXlHU7h5gj5eHAIAh6GIjTTnF7AOTFFW3kb0NEZrMtKODOF6XHmB/jk
	o=
X-Received: by 2002:a05:7301:da17:b0:369:f97f:72c1 with SMTP id 5a478bee46e88-3768721429dmr484316eec.36.1794342211133;
        Tue, 10 Nov 2026 12:23:31 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:147:2742:6545:702a:2431:7dca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520cfe29fsm10076615eec.21.2026.11.10.12.23.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 12:23:30 -0800 (PST)
From: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>
To: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>,
	Kees Cook <kees@kernel.org>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mel Gorman <mgorman@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ketan Bhardwaj <ketan@armoriq.io>,
	bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	"HARIHARA SUDHAN . R" <harisudhan@armoriq.io>
Subject: [RFC PATCH v3 1/6] docs: security: Describe the Kernel Assurance Plane design
Date: Wed, 11 Nov 2026 01:52:41 +0530
Message-ID: <20261110202246.274-2-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110202246.274-1-harisudhan@armoriq.io>
References: <20261110202246.274-1-harisudhan@armoriq.io>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uyjmgi8ig8w57iba37gpi7hskndypewf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 099A416000A
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794342212-568504
X-HE-Meta: U2FsdGVkX19TL5zqZpsV/ttzT7WDCBjn0UCoSoHdYNk1aKOZD++uFF7JT0yX4D1FrUCU4xTnIIndPFZGQccYg01IMSHMtb7qirk8U9E6//tSLWWrA4bsMX6JYrSlUkr/1AulOOvrrcDr+yAbYEUSbcLi3OsyzQavVJ3MZtvRQoUVKKSiv6YbQW27/2ST/k2BFE8BhYAyIJWlM0ix5vgMaRl9+VFf6MTi9732KgvsCYUHUtBlbdDpQC2ArbEDwEhp4EzUEDVWDmZd3Tw1dWZYsJiQE2htJsSufnIVfXgTUoutVLQl+R2WUWA2A8HZMx3L2Gi3BHrKp3pzvEby5VCWGICyIaHRzkoOqKMXuG8PNpnAGJAIJueiDxBb3JY6v0pEVrb98cASHXKWyrT8XroshcsPgkGjutlqVjvVcaF36Pz1AQ2bzieL0X95t23orhy7Xrp17ax8HnaZmcbvWRD2dUVGkq5cfxmEA/wL9TpZ5hVu4S4Ta06EMJslmP4EeM0nO87gaafPaJnuKE3Hxzb01hKXXkVNp3Gw2KlXUCFF0sXz/Qg6eupTxFkzgQRbRd01jMnER8RPsB4KFmGIi/QOGnceGQgtbi9zo3f0b6fXMpnmQtqXS09KN53EuGzzSc7sKSItbhjA5Lxsj0CNNGPrVzqiLoafp71VX3jJCoBrzCBt/8nwxwLcvd7AgvMau3lCwJeVpR5UCsSiI6U0Ntsxz+DMxUFjMmo2X+xvBfHD46UiT/iyjekAb2sLgGRbYSSx1E7X3spzDooE9Xe3ux+d5dShnj+jZuvrDUZLxo+LgYXiRSZgHyrzOdISffqYDJxJNDydGOBYvJGyoHy4D0h1+u6TN+NSor6voHvc9FPxwQnIGtrn8Jlsj9w5/RYUAaBmyoDBe3pLhCFDcZwsU9aLQ5iFDlS1eBenoyJR314pR0JPOT686JAQYDE/6iz+VMdUxifU6b3HoFpf2LA7Um9
 yusU7Fwa
 yP1ipBY/1yxzJ51Z3AdKLPZr4Qdton8kRhWRRqqrF+DR8zpBjYvTzIabJJup/jxn0KqqaAUa7cVT6sVhj8/h/uuxAh7Q484Ybvj/qmCB1WsLIh3MRoWVZ2MEP+gt+YNfvSBYUvRaB6rVg50OraxmvUvsOWy/VbXP1kTJ6O3PU6Ubo7V4z/p2iDHdeRZjMOXwlooxGFOqyxOt1FnFRROrW7po11/umDSf6XmucbXFxhSeNdoJtf5x6/E/S62cL2BHLGLhrfacP756gfVBY1klWu3ibsdYUfp8n9dzwlCtZsaD29U27Lgcqg9wL7oWsa5RY6F5FEK9x71yIuZR/I+rSk7tPsMvoqQpz0IEkkzJxiFyYy1Agdup9LL0bxF1zbBZdSZnnBGHzWX6tUbtg04x/KVMcYU40ai5Om2x0KzJoFohESUJysD/vxs8PDZub5O9bP02Vghg2oOHcnxY=
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
 Documentation/security/kap.rst           | 335 +++++++++++++++++++++++
 3 files changed, 447 insertions(+)
 create mode 100644 Documentation/ABI/testing/securityfs-kap
 create mode 100644 Documentation/security/kap.rst

diff --git a/Documentation/ABI/testing/securityfs-kap b/Documentation/ABI/testing/securityfs-kap
new file mode 100644
index 0000000..066de0b
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
index 00650dc..937193b 100644
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
index 0000000..e002a08
--- /dev/null
+++ b/Documentation/security/kap.rst
@@ -0,0 +1,335 @@
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
+O1 finishes its first stage. The controller advances O1 to a new authority
+generation that is narrower: no package cache, no network. It writes the new
+authority and a higher epoch to O1's igroup. O2's igroup is untouched.
+
+From its next check, an already running O1 worker is held to the new authority.
+It cannot reach the cache or the network even though it could a moment ago, it
+was not asked to drop anything, it was not restarted, and O2 is unaffected. If
+instead the controller revokes O1, the next O1 check fails closed.
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
+  Monotonic authority generation. Installing a higher epoch fails every task
+  still bound to an older one closed from its next check.
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
+  none). A lower epoch, or an expiry already in the past, is refused. Writing
+  an epoch, or installing authority, also clears revoked mode.
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

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.53.0


