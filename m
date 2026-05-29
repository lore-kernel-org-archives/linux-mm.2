Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB12FCD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2216B0088; Fri, 29 May 2026 08:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3990D6B0092; Fri, 29 May 2026 08:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6116B0095; Fri, 29 May 2026 08:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EBFC6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:41:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB32E1C0030
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:41:00 +0000 (UTC)
X-FDA: 84820417080.13.19EA309
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D5E818000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:40:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pr4rYFic;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780058459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zm3OidSFwgLY7wEpcW0f3kKbY4eYHAKurNfBqmFwEMM=;
	b=OzVrnN2OwGiIZJftFx40FF4Nucw0pXheiiPrYmvLByB8EO0WJcsXrYm2NhtG2Z3KJz0d6l
	1o6QkO/+lIJV6f03CXH+NoKb+U9UNa1qEhYJH2W6m5j50yLTT3LwRyRKlhj9i3eNJQVZuH
	FirNooHOX282vfLJQIkKUn/sKuc2t6w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780058459; a=rsa-sha256;
	cv=none;
	b=jdEay8lmAw7ufKriyYLPW/JZ2vyZKBQ6h71vf712o3LYNnjH4qJSFzt9toKjAgzXblIUMG
	teKn2DwT2yaHyus2xV3xKJ7fLdXsWKMlO1KARGTc5ac1tnrXBphNOcO1PndXfQfndhNdc4
	78uGEGp10vLllSndI56CsSsknwc//mc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pr4rYFic;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA5F860598;
	Fri, 29 May 2026 12:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7D11F00893;
	Fri, 29 May 2026 12:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780058458;
	bh=zm3OidSFwgLY7wEpcW0f3kKbY4eYHAKurNfBqmFwEMM=;
	h=From:To:Cc:Subject:Date;
	b=Pr4rYFicCNLoe7aY3SbNVvVErSthBrXvXoeaYNY3hGmDN4+SKL/oUcQkFNalnmXMR
	 VrRndI/jHIFRyE0hZpgZ0FuRmOftrkw9rDacvV8httBx4mK4XBA93144MmHYsBM038
	 /7MbEOzM94T8svOgRO5iGZfgXqYSpVpIopv1Wn63z2pG89E4FcHkkOtAUsvlaoxldE
	 Gjgu/EZhAd4aZTKl8HJkPBGZfJ7UBpEXOUvB/Y+zfs5Cb++5R6imCELHolcgDOoIDp
	 SuEdGGrDYhLl8tKtbgfSG0713mO5SraQDU/QP/nruYTMH5sy17537g9U5ojEPhd1Pt
	 KlFPGwHYHB2OQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: "Pratyush Yadav (Google)" <pratyush@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Daniel Verkamp <dverkamp@chromium.org>,
	Jeff Xu <jeffxu@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	linux-man@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] man/man2const/F_{ADD,GET}_SEALS.2const: document F_SEAL_EXEC
Date: Fri, 29 May 2026 14:40:44 +0200
Message-ID: <20260529124047.1483026-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1013.g208068f2d8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D5E818000C
X-Stat-Signature: t8gxb7s65nn54zz85nxioy45fxkbx1ae
X-Rspamd-Server: rspam06
X-HE-Tag: 1780058459-153859
X-HE-Meta: U2FsdGVkX1+/Uj0i5c4m1xz+xzun0ZgufikaMqo5YAeIoPQreD4AFLXhmUjvBMwXdcWJ2WA36JAQT8K1cq/on6FOIkA6wIRptOCc83Z2I3pDu/780L38tqm4JYjEAjPApTDmR0yLUcGRODSxIEX2IRpfxVAmHphaoLZCjgmydpH3sKdUvqz8xyg3Fts7/Xlm0NENpMYcpxobHpm8zii+ProSijoD9xJdyXlwxizk8dsZ7onQnWAv5Jua3bCQ2As/X0zZg/e1dAQtFo1TmFCEVuLdVphH7xjUqYMD2p6LKvYYucgXrXBy5zyU/4GAN7K5FXLuBtPLIPmJZ3s/pQaLCtjyIS8pP7K0HoFGCVAYmkqWsubHNme9lMU+Jh4Ogxx6TYfzNkG5E+XhH4c89xbXRSgq/b9bVrok4wVRuhRvRcKnZWokrsgX+mBsiiAFrR+E/f3C/NRBZmlA5tFhB+xLfdGbJR6rY+ysg9fVoaqhJZncDH1Xk2GB9cuPWjZdBW6hp9dovIHzWSt2zWWKAKasbFaIEwDeplF3d5Ei8OuojwLIH8KASXldwEkFUnj/MS0gSgLgX4+M0WOSEriqucU5h3LEwq69/5CZpu5IpLkogPl+w4O9oV+5U9aXSYppdXZ3mwLXSMSx53WQRIjA/sLWdpRwyiphivDZ73YudeXMoVGEE4WXRsEzBWBsj7J4L+XjanyhRr1+szr6Zv7RuVrCYAC8CprweY4QwPZiuetYZVpYbwQNiHE0No+q9oxwjXBWVoSb1PXVdVFZYImq1pTMchrJvu5bAeOfTWnCkRoeWbZSu76c4wAJmCHUiDX9hjv2uPJjEon7V5MsF7mPrqaA/CTj3Y3u3tnG/joHWBmh3x3kKButMOLcqPzK3nYnQ+HgePDdszlA4pywiVt6reQzsSK2/HkRpzBKkAuMoUBj+dR2vekpedT9bk3fpd56G4xqo5Lk29OVCMLcHGjbs07
 vB95wYAx
 1KeuW08YDVkoV63wh5UyPbycez5FiR8xao+ow3QwtbzDluMxtIE6Olth6slOZiTZHTTSYyUctCM04ZckX+8ZSV7FAjH7KjDtf0Sa1MVuT7cSjda0XuXfzXZWkpgg3OxCJvjCkVeaDm24I44Fes0hMrY8cG0Bg4LVSAnFjyhg/a3t2gStit5qESIF1gqOt0W/XSC9wwI1QUVBLoJ8WyaJjh74IBGcHdOeBd41lQucHnF/ieovsqZZuc6gNOlpiBcdZ4QFFwWgYgyYg4G3P031+8os/rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

F_SEAL_EXEC was added in Linux v6.3. It seals the exec bits of the
memfd. Document it.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    I discovered this was missing when working on [0]. I had to look at the
    code to figure out how it was supposed to behave.
    
    Disclaimer: I used help from Gemini to write this patch, mainly because
    I don't know the man page syntax. If the man-pages project also uses the
    AI-assisted tags as Linux, feel free to add:
    
    Assisted-by: Gemini:gemini-3.1-pro
    
    [0] https://lore.kernel.org/linux-mm/20260505133922.797635-1-pratyush@kernel.org/

 man/man2const/F_GET_SEALS.2const | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/man/man2const/F_GET_SEALS.2const b/man/man2const/F_GET_SEALS.2const
index 175025c10..2de8009a8 100644
--- a/man/man2const/F_GET_SEALS.2const
+++ b/man/man2const/F_GET_SEALS.2const
@@ -176,6 +176,25 @@ will fail with
 Using this seal,
 one process can create a memory buffer that it can continue to modify
 while sharing that buffer on a "read-only" basis with other processes.
+.TP
+.BR F_SEAL_EXEC " (since Linux 6.3)"
+If this seal is set, the execute bits in the file mode cannot be modified.
+Any attempt to modify these bits via
+.BR chmod (2),
+.BR fchmod (2),
+or similar calls will fail with
+.BR EPERM .
+This preserves the execute bits as they were at the time of sealing,
+making the file either permanently executable or permanently unexecutable.
+.IP
+If this seal is applied to a file that is already executable,
+the kernel also implicitly applies
+.BR F_SEAL_SHRINK ,
+.BR F_SEAL_GROW ,
+.BR F_SEAL_WRITE ,
+and
+.BR F_SEAL_FUTURE_WRITE ,
+preventing any further modifications to the contents of the file.
 .SH RETURN VALUE
 .TP
 .B F_GET_SEALS

base-commit: 9db8ca91f920b9aba40ed68de6b8da0ca9dbefaa
-- 
2.54.0.1013.g208068f2d8-goog


