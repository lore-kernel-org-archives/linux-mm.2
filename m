Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953ABCD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0588C6B0093; Mon, 18 May 2026 15:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030F66B0095; Mon, 18 May 2026 15:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E898E6B0096; Mon, 18 May 2026 15:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D52B26B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:12:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E9C2140A56
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:25 +0000 (UTC)
X-FDA: 84781486650.07.C5857C0
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id AF9B18000F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gn5wIQUT;
	spf=pass (imf30.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779131543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SInUWKhqXZ7NxtmtUcTjuIifSi8+lTWwUFzMJGjUoRA=;
	b=kWVR3KaHpeuQ++XlsZZl+SvAi+JauAhbhirThy/1ihJn5QSuOb+ljGjWYeU0Z4CTCT/JOy
	ue+u6IKC40HyjkBUQzf8Ba5fZCBIw4biPNQtGkqyZ974eHGaRPJ3RvxzomF8hzwVmrKCZB
	RxHY+Sr3ASEmc4ZvO+4WCkzTYxu+KxU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gn5wIQUT;
	spf=pass (imf30.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779131543; a=rsa-sha256;
	cv=none;
	b=5tzKk66H5xejJRysG0AppWl6npjjnEO7Iuv7DouU5X7sOo3pP7KLLllQTvk/+ZVrgOZkd5
	xZp11XOqQDo3ysw418qWVNUninmVYQVRfkBH43R552p4gRCrWc94Sbd73UwjjpLoZWRxyM
	5ZsG1xQgFsWPfcFa5lZ+ySHkFzEVYl0=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so29491765e9.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 12:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779131542; x=1779736342; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SInUWKhqXZ7NxtmtUcTjuIifSi8+lTWwUFzMJGjUoRA=;
        b=gn5wIQUTJVPxJg1D2S2UnJ+XkkS/UKcZ/4/1IMz2LG09Cfn+N7oxvQEVedC3rLDvXG
         5oRuhf303M+wkRKkoN2s2mC+/tIiHWHhH5GDixEWpWVumD/PW9PHNO23+y2emmbIiM/n
         4+fPfRUeX8MZWfMGqU8H0NMaDE6yImc1dbPgeIStByTSMKAL0mvmdgqQWOV/9ahsRHWR
         gYv2wZ94rIhHaUXbWLGRoOk2qguomgcJLvm4FBoTqHEipJoIiBc1dUEBTQ2MV5TIkeg4
         KTwE3Lp5iYtyZn+JTlMFjCcbQRmhOmd6quwgUE+u2RE2bSihNFIRg/5XvK8rZ1dftlma
         MKsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779131542; x=1779736342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SInUWKhqXZ7NxtmtUcTjuIifSi8+lTWwUFzMJGjUoRA=;
        b=nTi2qw59WzwvLozMZy433KSEZ4Atr9e7Q6TISeVK9/0Xgjq6ZDMAPZjQCdl2BBKIBu
         K8YlN7D6WzKcEhtWjGlUQv9N78+edCte5E1Or/338XvFVCBB3gOUrp0Wm4F3UMJV8BkF
         OHyaAifpuWQGX6aoAf7zHuT1YlwzJ/DeXFKD4QbfRGwnC0jjVIffVY8Azd6zqEMjaHWE
         1xJTYk/vo97DiNktqMKAH2/NRJGF2khLyzKbmuuF8iwMBb6Ca+72Eex1Nv7M4VkX4Cbq
         heR8/InzZb58N3JEJ+6qdxmH3IjbMQbU5wdMO3I1uNpzbINLVf6fArh/AdMdXRt5IzqX
         nbNA==
X-Forwarded-Encrypted: i=1; AFNElJ83+l9OJbIfsplLHJnpBd6DMxtvj5pJ/sdLXPuAtz6563k04g3pyiskxtvtYN2dgAzDs+9bPUV7Xg==@kvack.org
X-Gm-Message-State: AOJu0Ywp1uCePoxSUOAtXy5b3d/q+FViyxdMp0qw8vryEovil1SPZDpR
	28Pbzc7s4pPmaVbyeVpaVEX4rcxgNlq1FcTJfAdzt0TrcLFhw8RdzWVC
X-Gm-Gg: Acq92OHatIn2nCcFcqm3YRHbhdRMwfO9cdBqafYC04ODmTanbZy+T2GB9o9Prn0uhrr
	1LkLfDHb5gJG2jPdzCn1Csj1wAfFmpDSy73xm9DqtQCQgOXb0tVv/VS0XGrzDgYjihN+PckkZlu
	jgYFeUuCMP8+rvQFoMOLeqmJWL1MozwFq2SK3cQu98xFuY+gCFL8jqgQa4Xk4B7G6UuV5ToMNr9
	p2Udz/Ufzt0VaVae42CrYfS8pNw6jVUTPSVdB61IGO0YbtY9vrNNAx0EJQDPIQJuiMNAUwH3qRA
	sUjHPT+Wzi6fm6cFad0Rc4aNoQL/6Zzd7ki79EkmNX9BWPT2Hr4tZx/rdGpHnbjXmlOvwyyUCVt
	yhAhRbIkNTQuy6MmQISZAgBYLs6+xE0ZT0yGEg337a8HMw0sW9Hy6Wn89p1msPaGuMAeYoKyxEX
	5hVu8RMXSn3HCtZGUMRLqZojAZVErI0zFtlFJ/xuL8f+MTOxv0xMg=
X-Received: by 2002:a05:600c:4e47:b0:48e:707f:cdfd with SMTP id 5b1f17b1804b1-48fe60e54f4mr274314295e9.2.1779131542277;
        Mon, 18 May 2026 12:12:22 -0700 (PDT)
Received: from mshcherba-RedmiBook-16.. ([188.163.115.207])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm40043167f8f.34.2026.05.18.12.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 12:12:22 -0700 (PDT)
From: Maksym Shcherba <mshcherba2000@gmail.com>
X-Google-Original-From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Subject: [PATCH 4/6] Docs/admin-guide/mm/damon/usage: document update_schemes_quota_goals sysfs command
Date: Mon, 18 May 2026 22:09:30 +0300
Message-Id: <20260518190932.42270-4-maksym.shcherba@lnu.edu.ua>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518190932.42270-1-maksym.shcherba@lnu.edu.ua>
References: <20260518190932.42270-1-maksym.shcherba@lnu.edu.ua>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AF9B18000F
X-Rspamd-Server: rspam06
X-Stat-Signature: m119o99bw7ok1npw3pmxnasoh4jz15ao
X-HE-Tag: 1779131543-535659
X-HE-Meta: U2FsdGVkX18F7JU2pWV4wvfYHyqdRPQYk05yU+VF1wpIYpffsnLN9TiZ+0tsmGvzarx4TsQTN8Mb94/pATF/TEYc81xNRGvQMiqJOwfh5nWkksCkAiksytCu25euqIK/lP7KuEjp3dIm28qzLf7QyKxjPO5TLf1/Rq2/I7PbFIYRp2ykzeMeS+oJbCO099XpTwXLX7Cr81uFDQnVh5y0d8WAZ05iXPmZBZCgZBM2cT9O1JrMfQxImeVDWdSyvoLG7prb7kUHkpJRb1asKtnI1Q+DAOa1YS4IlTD1a1KeH30q5z9dxGYoKjBmOGPMZjVgFeDQYvX9ZuJuGqUEXcvkYcX3imNXi7lruJhcmX87nnGiGviiCCJNEPlpQ6gLb1BGY1Cq9Q4YZR+sNHsEMgl8fh1owzyjp5QZF+bVAvFbNT5xb/Db0JevR//YHQdkPC9hOl1q/+oDjT//KL1MpNlNCLN5LWCYlxOFUr7sCxOzQAqsjV6SHDz4Rg6+//N6wDRi/CvE+Mh7uJQehiEahrcEwD8TFQEC3+pmy9LVWHQx/ZuCoAqWK2urUoiK8h7rrZi4337B4bMHrn8mYvYMDNne4RkqZYIiDoJIJf37U52iI/R0vBwJMgMRsfpwXK6uTDfGSP1Hml/AUfDiEg8acASlymNU1sJnda3YWdXAejFWHHBhZ9jEDJRdzuShlN/Po/PJfM/URfQhtGpGVGOvt3pSMIgoPxnzr3y8IU4iRtFJWXBd8tANWCUAnqL4a093kevA/tgzrtPRy34FcmEHG2jm2w2Bal8ZeKVRYJXgz8a9T8X2kgQpiNIxCeBoJtDA/4dnZWtnQtcGplouNizcV/r4dsJdsZwvTVoToOyM61IP1BInYLBaxdtYrekeuQCItnK9hGMpk9ojmafIsII3pRUQQFHH+RCyJdBMPU9lsX/z64V/C1L0LsSYB4gB3oPgA8Ba7bVZF0DFxCR38FK5wf5
 GebRtVST
 ITXd9TIPx24s8CA43rOv9hvE35nIKydKbOX5T2GEESswV6/QlZhD0ISYADXvU05eh59CVRcCPf7ViRVQHvETgCZTEBqSI+B6yFIGmKL7klp6vsYQTdxE4dvcdaJkfKDpppqlWutYq8XwzJ3vWbkh5ll6OAIMZP0QlcUf13dUyBg+iuwLdL7M4x5d1Dcwx30rjFciwl8U6RvvD5nTmvWR/v/ZhOf6gDl6a1lw1q1hbcrZHh6W1HTtuwm1nnE9bwxMyvqI74/wB9A/ld7G8Qg4HykQ2EFOuYb3w5XuKl2RlQEBiJpIsyGlg6LR5sW811lrWn6beXTxie//rXNU/F1uGfNK3dOhRBxCTLM+/LTppPTL7q63XncfT1xEXJjmjZo3hhB2k3h2XPihwxaz2pzyB0GibD2OUEwmFmH99yS9wzSSKU3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the DAMON sysfs usage document to describe the newly
added update_schemes_quota_goals command, which allows users to read the
current values of the quota goals after explicitly triggering an update.

Assisted-by: Antigravity:Gemini-3.1-Pro
Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
---
 Documentation/admin-guide/mm/damon/usage.rst | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 11c75a598393..097d8ebe960b 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -167,6 +167,9 @@ Users can write below commands for the kdamond to the ``state`` file.
 - ``update_schemes_effective_quotas``: Update the contents of
   ``effective_bytes`` files for each DAMON-based operation scheme of the
   kdamond.  For more details, refer to :ref:`quotas directory <sysfs_quotas>`.
+- ``update_schemes_quota_goals``: Update the contents of ``current_value`` files
+  for each DAMON-based operation scheme quota goal of the kdamond.  For more
+  details, refer to :ref:`goals directory <sysfs_schemes_quota_goals>`.
 
 If the state is ``on``, reading ``pid`` shows the pid of the kdamond thread.
 
@@ -448,7 +451,11 @@ get the five parameters for the quota auto-tuning goals that specified on the
 :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by writing to and
 reading from each of the files.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
-directory <sysfs_kdamond>` to pass the feedback to DAMON.
+directory <sysfs_kdamond>` to pass the feedback to DAMON.  The
+``current_value`` file is not updated in real time, so users should ask DAMON
+sysfs interface to periodically update it using ``refresh_ms``, or do a one time
+update by writing a special keyword, ``update_schemes_quota_goals`` to the
+relevant ``kdamonds/<N>/state`` file.
 
 .. _sysfs_watermarks:
 
-- 
2.43.0


