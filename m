Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA03C606A32E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 16:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CygacwR9
Received: by kanga.kvack.org (Postfix)
	id BF6556B05B6; Sat,  7 Nov 2026 11:57:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6DA6B05B7; Sat,  7 Nov 2026 11:57:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A952C6B05B8; Sat,  7 Nov 2026 11:57:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8432E6B05B6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:57:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A724BA7F6F
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:57:28 +0000 (UTC)
X-FDA: 85408928976.08.2465A00
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id D7E3E120006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:57:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CygacwR9;
	spf=pass (imf29.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794070646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzXak3ntRziJwCOaF83EBVAeXCmgVGHqVypHFRPQte4=;
	b=VDtirSdtA0/HJDraRxFx+t3ZaYpoios5/zjjP3sM5prk22CHOQkzz8rIDkvxJpJHBbUYh8
	oTgUw+K92EVhg2PomMZMaqGDe0zJaRDRdXXIxEPtRdUVbIx0fimVdZe2zLy9Nus2foC6zX
	7nvoNN4hvl/SFEF13xxMY26zl7hw/sw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794070646;
	b=2R8pooxksKPUIpmvOb/SColywhrmB+ef8o/rHak4A4B2rpG18/bihBkP1bD5BtPkx7ZVFx
	YJJyj5GHV51z0uRvzf/6aetcHiVlksbTahrD3Kt6Ly0X5POwOZOvImytVO+F5f500HQqPS
	Vqgy4t90oIRDDoga8+pqnY27lcSLhK0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CygacwR9;
	spf=pass (imf29.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1a3c08d6928so2896798c88.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 08:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794070646; x=1794675446; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hzXak3ntRziJwCOaF83EBVAeXCmgVGHqVypHFRPQte4=;
        b=CygacwR9q2Ig06M/s7vA3mWOL6j0P008+2TA2ylGujPdo80UGbQjJKSbIQ07TAnuz5
         v3p4UJxksWLexLXqYZ7Jj1wIa20vjAmqgUrpWxarlUK1Ok14CRy77+jpwdD+SeAAvmwN
         z3BMI+IW7rk/2vk6CU57j3Xmxp75LCnVFlhLewbbcWcwMPhvPz04nIDLNDfoCbDOqGc3
         K8TLXSAtoPDSkbwIi3qeDk4aDeefOjnNrgs6E95tMa8TClhEmHi5j01Jn7oyB0wuOdqN
         Y1nJ6wsr0XS75v36jyh1QIocU6KlvzUZ0K5UWYHnf48qtdYkLQ9EIak5GXj0mM/7HFNb
         es1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794070646; x=1794675446;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hzXak3ntRziJwCOaF83EBVAeXCmgVGHqVypHFRPQte4=;
        b=D/rq7aQs2hzLo43ckZKYzf8w3g4cT2ngKCOU1VU7vO6Myl5/38VwWQR3yR37zJ9lSI
         4kswXRPtWhW7hyDWsBeOjAe9qVxClPnDk4nDgmRXOkWb5f4qrGkAGHHPlq8j7ma0WUgH
         T5yB6qWbWpId9VfSQmoAbJ5RyHtBRjK8sP6UN0i88yUPNHZL2p5Bc4WMbzQ8AVew1itW
         7ysRhs0mKlT1w+OAb/S+tHr0af95VbAFl3sQOVPb9td6f0BbukUmOE6Fw6eOKij9e2gv
         gAhDI91G0s/HZoD3Y02Hk7IRluxK+dBPQnlFuKyi/xQRSah35g0jzSACdTyIlMmY8GDr
         7MqA==
X-Gm-Message-State: APuU4Z+hCYtqKLT+lCympHEQ9W2Bht+jENsrHQj0j5XJg54Xopb8TZwV
	1WdoPeJJ/taRbbq17SRRSBNTE3lRMjuPMP5D9P6Qn8ncnK4oJHFGQW90
X-Gm-Gg: AYBFou29fsBY6Fk3vPbPJ/l7rb/EDQ2RoYW0c3snZfbh0FaXEq6coH66Jamega5rC9M
	KWv1+Fqjz0xc+4HJkGII5v7vhNxBkmgTnXHf9hTvnXxPkLG0nF2T8ODviUdmtAIf23srG1YXFOM
	Xge6HzemFas0npEvsDyey7JNlCXJCcS75Yk3alc2lTwoOHCM6w0ft1VlicfqDl1EcG84IkTv9/7
	yDI+C3pmoU6Y9mkP9VRcTuN+e83jnh4gvG5W0pVMRRQvTn1N3PRf4C/NOZVCCCGrU8wVDzyvjf8
	LKC/Boo0c5oTuf2C6Ufb+yXdKg1f2FFxY2HSkvodJ82kj4YJc5QdD1EpIjaPy/KreEFb4XpnGP8
	ziU+5Mqu3GyNKKlnlKzefYDbtQ4rRzrGmeRFqiGVVUAOE63B4ccD5yqeo4f6GV7Fs/RD9RBWRo3
	LXVTrYfmBTUKgi1FxqFlKK6Jsx+lumOFPfnQFVAElBgWi7Wu5fhNMsJ6YDj2zmTnBumn4cxqj6Y
	I0BUZtmxWByBzlQlzFHleCEUU4i28VmQqrA8t7DuK5Py40Q+JvNzXZmamQo4adrvSxOmiIWQljI
	CSn5m3bMGn7+THxEDe6/8kf7
X-Received: by 2002:a05:7022:5f07:b0:1af:16c4:d06b with SMTP id a92af1059eb24-1b25d31e658mr6932727c88.10.1794070645481;
        Sat, 07 Nov 2026 08:57:25 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4b4aa7sm15456126c88.13.2026.11.07.08.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 08:57:25 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sat, 07 Nov 2026 11:57:02 -0500
Subject: [PATCH v3 3/4] selftests/mm: move waiting for KSM full scans into
 a helper
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-3-16d5ce8b5fd6@gmail.com>
References: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
In-Reply-To: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1cjyiizsxuipaxy1dig6oi593hzxbfbi
X-Rspamd-Queue-Id: D7E3E120006
X-Rspam-User: 
X-HE-Tag: 1794070646-549618
X-HE-Meta: U2FsdGVkX193WHocSrw9cI3yK1KUwhsYv+r7/50wnln69aeI2aPINaxlgC4N/QFWde0TBIYsSYvOFytr2wT00EmnsRavsPhqLUVfgOsn0aKWavNbsnhV1VcsLvbJ9yrGIQ6mQuy9FHF5Io4hTh9gKNudH1P4eSJDVMjJ0I+6brGiK+GpZByBLZnitFiRDOnsf78ihg6dyZMVAFJHTKdsY8f2D/6TK5nLirnj6OSGrpqmOybh2Jl7wJZ9hZUyq4Dq4pa1G6izsAg4I9UEc5JbmHYBa4L5eoImKjcXu6UbdvDiR1Y5KZoCiZjPBAUu/i91hhOFqByLvBv/vipTtdzEM+z94taq1Nl+YSjbTBYXK8WIYjdWufWyEV3bD7KqmeUl3iVm3RRFEogEZ19+6JmXjB6EmmMc3Rnvh6B9Ccm0uc5/6CU84blMtxSyEXgfFeQClWST6UEhwNd2ZK8IGM80goDwcPqBVy8T6o7DCShHBxqduyin9tJ1kl8Q5LCz1tBgt6Bl13i+2PCkpZcNr5MONCHdXFmDWCI+HrbScxEoTYoqQRli/spgF7acEDfxDvVGY4I8pO26HTMqQad0zUbyfKNbR4B+AnaIDgGoujqgf9THAz0b3e+6ViLw8HvxZ8p4/qcmg+jeFON5qZJSZx6e2BVUeet9j3syZypCxJvPgpOW+NJknaqsQb18P6aJhDxUzcAl8lBcnUZ04bXpKjqI4Ams9msTx50AV2eu3TtmtjMWS0Z9wAp/jWFw/8KcojZhVb0ciCwUwjlWDDnvfN5Azd9XI5BlPHTFHNbNUqXHD2/rqfNuCX/2/CoBzOgFh3gJBIAj4O8X8lFwco/DHNqV+SxmWADsvRG0ymDNz2usCsmcqgeOiRxuiu9Q1c83UN5L7qEUhIazed+U4/QqYiPKuDbDgHorSTj0vSemiOqo2DCdkqslX2y41Uq7xzeSN2BHBdNRMEg4f8XfF8GD9nt
 W4syl4A5
 32mdQFW7A+fml2CpxzONBkvQrCLcO1vwM3Jktqo19jWEOhf3EYdUoZnEVk3Pxu3QrA6xeyDMKXP0Ejun91Uy3SReJX84e8mHDQ2d4FDKuUfCvf6rOBxiV+G4/H2ATVc1lzfR92F4qtkeull9l0mnqEl2rOWUKrINGzz9WGZqXUg0q7M5O//+KNSqnSa3NqFy0N5K2ZmDaRnhiPxGrAFM/8nZRnlXP9ldBxCaeC0+uAcd4c27jITNs4t0tqxO6yYY8+hKrdE2NJL4wQBcCccAtC5rMcpJXs6/GQqs4pXfwZy9QkpUkLDkDka+2BOr3eEa1pcfEt2zGepgNP1mltwTLvaOQlMxyzYkiIW8WQQMjSouQO99QqZInqVFgdhs3saHzYo4ieDemHk8xluMTPIgKzPl87Asl7EmyBeZELyPgLi4rFI43SuMtQl+nUrLAslLmvafsaaSaKPnhy0PDYLqB9j+uW1FaDSEK7ovZcKn0Ag4gO+Qqxgp7KWvALw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ksm_start() enables ksmd and then polls full_scans until two more full
scans have completed, so that any merging that can happen has happened.

There is no helper to wait for a number of full scans while ksmd is
already running, so a test that needs one has to copy that loop.

Move the loop into ksm_wait_full_scans() and make ksm_start() call it
after enabling ksmd. The count is now read after ksmd starts rather than
before, which can only make ksm_start() wait longer.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 tools/testing/selftests/mm/vm_util.c | 31 ++++++++++++++++++-------------
 tools/testing/selftests/mm/vm_util.h |  1 +
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 515031b8283da..1c2bac54696dd 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -984,33 +984,38 @@ int ksm_use_zero_pages(void)
 	return ret == 1 ? 0 : -errno;
 }
 
+int ksm_wait_full_scans(long nr)
+{
+	long start_scans, end_scans;
+
+	start_scans = ksm_get_full_scans();
+	if (start_scans < 0)
+		return start_scans;
+	do {
+		end_scans = ksm_get_full_scans();
+		if (end_scans < 0)
+			return end_scans;
+	} while (end_scans < start_scans + nr);
+
+	return 0;
+}
+
 int ksm_start(void)
 {
 	int ksm_fd;
 	ssize_t ret;
-	long start_scans, end_scans;
 
 	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
 	if (ksm_fd < 0)
 		return -errno;
 
-	/* Wait for two full scans such that any possible merging happened. */
-	start_scans = ksm_get_full_scans();
-	if (start_scans < 0) {
-		close(ksm_fd);
-		return start_scans;
-	}
 	ret = write(ksm_fd, "1", 1);
 	close(ksm_fd);
 	if (ret != 1)
 		return -errno;
-	do {
-		end_scans = ksm_get_full_scans();
-		if (end_scans < 0)
-			return end_scans;
-	} while (end_scans < start_scans + 2);
 
-	return 0;
+	/* Wait for two full scans such that any possible merging happened. */
+	return ksm_wait_full_scans(2);
 }
 
 int ksm_stop(void)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index b5d59729d4327..7e00030077d2f 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -162,6 +162,7 @@ void *sys_mremap(void *old_address, unsigned long old_size,
 long ksm_get_self_zero_pages(void);
 long ksm_get_self_merging_pages(void);
 long ksm_get_full_scans(void);
+int ksm_wait_full_scans(long nr);
 int ksm_use_zero_pages(void);
 int ksm_start(void);
 int ksm_stop(void);

-- 
2.43.0


