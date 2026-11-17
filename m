Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A979606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U8mBhQAO
Received: by kanga.kvack.org (Postfix)
	id 817066B05B7; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8756B05D5; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307CC6B05D8; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEE346B05D5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0AB1E160504
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:13 +0000 (UTC)
X-FDA: 85446189066.19.3710C9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id EDE0BA0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U8mBhQAO;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf25.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794957791;
	b=VUVUV9Bgq62vRNBoL32ysPgl1zFvgLiqUFi3vPHwAMXKtheOkc1m2Pr5uesszD+oC7Yshv
	ExUl7hM6B5uixAuXg3tdi6LHM6r1EiVVydfwZRjgnVZ2rF/3oZVpQyxs2mlMfnD3cFvweE
	jBV5X8GiQAqjQHR/C2pRSi89q4WToYE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U8mBhQAO;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf25.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957791;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ymyID5yWGQWOMH6t/cr1gAlkP/MvA7c8+VMex67FU4=;
	b=TFLbHUk8qgeNfrn/tzW/cDjaYef2HNf3BMqlyq9qPBEEqdwaNtwPi2FIl4kis0mnD3BXxz
	+je10crienQ20/pJxhGS0HH485t9KrwrehOciwmQ97xdgjuqFwfIq7lJdwpsJHXmUbTm7h
	aHhP8Dexr4qALyZZ9B8UTIHCUbMR20A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83E7C61D86;
	Tue, 17 Nov 2026 23:23:10 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794957790;
	b=ktMvhGFF1UbTzTB8w2d1oiRSoVR0NdUbkXTHOaC9/si7aBgd/VH+fxdl7Euzk0eNjyr7
	 0F9znOQPgG6fckmtlKBtLp3b69hjYxVSiZAjlNLiDF724QFEKxdDHRdmOkPu6yMKaCedY
	 bf+2UuHDMyPbhYMrf9Mz7KqI7FDAn/pJYd/9zLpK6BRe//3i0Wpzy5Wa7mmYHHOTiiBfl
	 wf3VBYcPweRz5Fv1lRN8iaCalfGI1yPIyaVZ5sy0vphpxBhPyOXX3aWiP+H0qchRyUaab
	 y+YVZd7IFZbkvpO3Ffk/N6+fgN8mxbRJ57Sy0/EUdQb/X3In+/FyOdjXm5uhYTuA6aA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794957790;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=5ymyID5yWGQWOMH6t/cr1gAlkP/MvA7c8+VMex67FU4=;
	b=JqMg32fALaLFm4SEcouIhbkANsVTfCYDs57rfi+BqDU9Mnusw8NOp3AtdK8kxG5hPtKe
	 VnAX25us1nsDbzJ8GlAzldt2YBwF8mcK8UHgmQvxVqAQgZ7YiiXU+vNOkzuf/z1GPLt0K
	 NyYYNZKHXgUb6MRrXY8bflNA6ZK6eOTqWneES3jLyDyl+q50TFIR02WREGchWVrG8wauw
	 0X3D3/i2RSAq/ko5MxNvA6w/1vcz2qyOLf/QOf9jzPGL2gbmv2trAHkPa21iF9joRCL5v
	 KPR6udeb1OMA5NZE7heyqKL1iDGOEpnGfSJnhmhlKtYK13CaCvzyZcC6d1u/SjBC7TQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 94D091F000C9;
	Tue, 17 Nov 2026 23:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957790;
	bh=5ymyID5yWGQWOMH6t/cr1gAlkP/MvA7c8+VMex67FU4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=U8mBhQAOtY5NvZKfcBKK+1zOEAqHTH0mTxmSF1SBVk/KR+RR+BDfuSK4TMVdQ1g3t
	 XIYl8zu6aijLLk1E6eHpxbh4kVlrnyeZe2qa+8w/C3effIquv5E5RpLcbACBVEqZv6
	 scXO+cYOi0aFobKntUsJG6BBGiydW5jbelnmIVh0tDGoLA0sffQTcA36z8b31wXJwI
	 /73n8t9JPQjY4Z6K3dHesFdNjWK1LZ8BrPsXKoAJTQ5ytUfD4sKjxr7vHbpu9mLlH4
	 oXihJ/U04sIQnYOOxC8ugChceaRPYdMyfPOEB40bgRJ1KTaeK+YNHTAaSBiYJbymH5
	 iXwxQZ0dk+HNA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2CE484AB4F;
	Tue, 17 Nov 2026 23:23:08 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Date: Tue, 17 Nov 2026 23:22:20 +0000
Subject: [PATCH v2 6/6] Docs/ABI/damon: update for
 sz_ops_filter_passed_last
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261117-damon-sz-ops-b4-v2-6-439888fa04ac@uber.com>
References: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
In-Reply-To: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794957787; l=1281;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=90a1wbT2PC+F+rhsnr9WMD8Unb+N/GP+Z2kT1pcYBmY=;
 b=pkBlnH43gn4zV/kWKM/02araP3z+bcuBHTyxxj9OoZ/EcohJK1F3SlFgD+e7Udmps9/m0JS/c
 7+wiCSdYnsWDurYzDel6oOypuSIIIpH3e+Bxz68U/vqDCr326+dQTM9
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EDE0BA0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1uzesboigkrc3rzm6p8bndfecs48es3q
X-Rspam-User: 
X-HE-Tag: 1794957790-974906
X-HE-Meta: U2FsdGVkX1++Ye2BJQWY20OWq9pwyESLKHeo5pwjegvAI3pkAZEXRH5ULVJhTnRYE5OrnZE9+R/jGolFROJ5vud7wZ5z4kt/EtvzZ1KmQtjElpTq3Hnm0bLbWepeqJEFCIbDq1ak2keM58AZFUU+UGD2Hddx+sAIi+ghlfDUrkPToixiC2ME42H6Am0T7q9mb03sMd1c3xc9oDwbYXms11B4Wc5vcT7jYbdPvbJPaUnXS4awKzFE85wXAVbUrSTXWMbxGd42RKplxIhvix4UOS8iBn0CUOnty39TtFavrCOjTBGfg7h/I4kiA0ey89yKWEfYbe4J+QEQAMq/HRqGy9pV/FNKk+dg5/2NS81KrHm8zObB1xjPgnLWxMOZdvWFMhbLJpPbjFf8oeMkWDJpCbLlEb8DpPpfclYtR2WUkDQug0AEj8D2oxfhEwz/q0vgbQ5oKQyvgP3PnqogwMnNF67W9jhnKdfeHwGkKKzRVLXTNBXBunXE1VJuTNwv6owUl9wJb4fR1ZKZn+iV9yz+Jo5+uSuklCFM9UdyFUAaRXDxsGo0JyquW1/AIl+9RY4BDZIjtkuOa1W56+TSqLFpvg+3Ik1lUiPHK50t59OOmRPUQBRvUM8m0h0B2WRqTJc5CKwYSoOi4Clo4+w8NFFpykHhgieNv51ZB/lnfzco7dFyIT3vEQBZP47Ls3iydZQP4OFAjd0y4vnB5Rn4HxJT+9ZY0Id5g/ggyyHCv2IheQEElDSq0HttaTs1HitYj8xjuOJiLDb2FIZq0/4frhfPrBjOvopzRRqRw1XOhdNPN51MP+VwxnHDVOF3nps/LvuiV2cakCiuDEOyXbk9hNxVwORKsfexlWay2RNr0KunC2qRuKBhp+VOwH2YKj7gLf/xYsSWcwSKzdh0oBb/kx8N76/ZGGljZ/CzzimP1szvn2EtEG5T8AQFjzie6iSsWDni5vHYCdvKsHyzm0rj4Vs
 yh3JA486
 amekMZloxBcLXC4rGdm+4/KDhSqwr1MMBBMY6V3nMXQ0fiXIJ80qKdRMk0yvV867QnqIKPOLUAm1ewEFkExCHdEPaIht2PN0YCiPoAHombT1eP2j7hamLY/6HTWx9oY1ibpgNavKwsVWe3TMYwYsn9bjUNkUn7lieWasIcdWOcKyDIk8J+LQ7Rdk1En10lDfAzvHj9XV1rWJaV8hFHjthLzUVA5MHaKEHsjAdRyOmNfBDdgb3Bkc5Ut4k2ZvoZLzoZEC1vwDRbC8fb0jiKiHSmNRD5CdLQGOXT5jq67ZFKVD0UP2nJD8AvQ4FNXwogU34+zVU0PkupgQvtRL29cPdQYs5gsmDwDrC8UvpkQB/Qq5U0oKjQmjYBY+YBNXvNGJtYdniV60C1HiiSaEiHe3lzzsSY3lOo/ogjECYR8wYg0NvqXxifiuFrEVilofuSjtciKjeLK9t0Hlhs6zhou33lbB5bIENJwJvvnrLDfYB83MPsRLQKz29/YhEkXdHpqsBOQql/PUzXHU5kD+fdubHTEJ1AMKvjQkO3ppTx71Ss0BZwVxx+ScMn07wEAZ3Y4PAL4Q9oBwCsU4RP/KyyxpELx7Jlb3wzylLpTlD6CZtiJG8m9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

Update DAMON ABI document for the newly added DAMOS stat file,
sz_ops_filter_passed_last.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 4acb2015c2f4..92348178e48a 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -623,6 +623,13 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the total size of memory that passed
 		DAMON operations layer-handled filters of the scheme in bytes.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/sz_ops_filter_passed_last
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Reading this file returns the size of memory that passed DAMON
+		operations layer-handled filters of the scheme in bytes, in the
+		last apply interval of the scheme.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/qt_exceeds
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>

-- 
2.54.0-uber3



