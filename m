Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 523DCCA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 22:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B72B6B008A; Mon, 28 Sep 2026 18:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43FC86B008C; Mon, 28 Sep 2026 18:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359776B0092; Mon, 28 Sep 2026 18:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F14286B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:39:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27CE2A0359
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:39:24 +0000 (UTC)
X-FDA: 85264638648.13.F907D33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9E54420004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:39:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jbf3WGwT;
	spf=pass (imf31.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790635162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZVWLq10QP6ozzOGLEiOzZHrsDG3MWGDn12hp7nFEyM=;
	b=FfWqk/3pu/jNeNN0Fz7ceQ5w5heKRwUmV+cexWaSR4l9fhaEAEUw7/Sy//Gfl1OhmPoUoo
	dS+XggBkEom+hLpujmDSeg+cSJSD2racJhQFcNhjlRBaHFT5JAXOjHSoZbxdLqIuNMALQV
	vF5MIi8Zewtamr5TVvkBRR0rooQqOpA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jbf3WGwT;
	spf=pass (imf31.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790635162;
	b=elhbl94B7UxkbF4fR+Q+6LpcoInBrlegDBFxJQzmeQRN7fm0lr8cAw3XLqjUoy/7Njx9Lo
	CNSJYETixNRF7VSWu9FXfDIJrVgM++BJ+fQ3CN38XYubpMcWUdt8vfyqbDfVz/1Q/Emles
	YmWXonWOT3OpiFrUS7jjkVktKw9aW28=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F8F66020F;
	Mon, 28 Sep 2026 22:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9921F000FF;
	Mon, 28 Sep 2026 22:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790635161;
	bh=yZVWLq10QP6ozzOGLEiOzZHrsDG3MWGDn12hp7nFEyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jbf3WGwT4gjsrZyd6WMg6L6kxTClEshwP7xzwtYR9LZYlFUdNMuLvH45mzhqky2Au
	 7Y2vx2gc1483ffxELAGi5uCU4CRoEvlw8gL5S5Kce98HHvndxs+6K4WzWQM1FCfhFh
	 yr8vBSThsDqLlV/MR/LdO+42444ThoFuKQqKX1hS91PcUISZOqPbYF84nm6A1Glxd/
	 CwTzLdSarBIdWenr0FLGm+VMc7OUe3HY2Qg3LheMucGW0uqHiRjsy0hr63zJQd/JXL
	 tW0q+0DI/MqE0CGDK7QKSdS1i2L1Q5i9EBml7Sr5QfjHxeNQhAfp5iTM2aposRkZrd
	 E01N7QfXdR1aA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	rppt@kernel.org,
	sayalip@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Luiz Capitulino <luizcap@redhat.com>
Subject: Re: [PATCH v6.12.y] selftests/mm: hugepage-mremap: fix mapping alignment
Date: Mon, 28 Sep 2026 18:39:11 -0400
Message-ID: <2026-09-28-2-daily-reply-0007-re-hugepage-mremap-alignment-6-12-v3@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928131117.231700-1-luizcap@redhat.com>
References: <20260928131117.231700-1-luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E54420004
X-Rspam-User: 
X-Stat-Signature: wkrxhyt3xspj8ocss99iom7ezgepn4t5
X-HE-Tag: 1790635162-366828
X-HE-Meta: U2FsdGVkX1/1uPq1HpZfC5hHulv39KdZx2blhTwJ/tRglOCKpcfI3h9EAHacj/YRIRed4fZQOgb8LfQj1+9jVMzrISnLm5KbqVJf2E6isJ65uTiyM25qBkoC+vYCW5HyvbiGu2F+S3SQ5LuCmryfpBiOJXTgaQTTpZt9072ew034BnonOI0aSJikScpwD1elJ4s8bseqMs+UXezTWZFDTg2+GS2+y7GYbNJpICHCK4Uh+mseE5plm3s4Hy9NrgxOpKI4jSyjuOiehuEmv4bgeWHA5+4rz0E/rgm9P1TLSv9Tvcuyhp9vrvroa7i66Rc0D0hFykK+VE+SGF2tzA6h79OlcqAHYqdLUZtr2IYqbyoxydPHSddHGtoMFXZfNBrJs+ZHjCe+ZBZ9E4wFwwIH/wtiFKfPUC2wULEZfwZxsA2sDM200NsiynozNz0mKrsKFsX5fKrxsGzLmoDlOAEzsh2vfz8pMnq+3x4GMN7E+bhP7x/P7cLgBppUrDRcf60dJDmZFps4sZrdSQo2SPD1hjU3IHiUP0Xm5SyHaiTkIC4Bm18a2FTWjte0GA6erP64v8WIQddm4X/f40mzq6r542fDFUr3kOJDRlDfI7KUlRCQi0/tvmdg4uN+PvooTzK6ah3pZRJ9boNX3iQYd4MUBBNMZIzIUVCYKnGyiiYDaTNekus0GWjqrOmZsmUX5XDitcbv5z6+hVjA1j1ToPHZ60mQSiISfoHSfneByp4aSG9DT/iUD4MIk/SRLQc2K7WnS7FqtOFLvINMtxnFAc7ziXeKtK+rd+2Y8+M9VV+rS+VBQPU49TdrEVFqjpegcnDHU40JinOpjf+SEKg1XhnVHoz5Uo4wHJ7H8eSYKbCm8sK3D/nBW0TRpnscsCJFVP9mdp4sljyINasF6bTCHGa9bXNMuGg8SJQFFMQm/frWL6vnpXo9Al5xkQHckjPvq2lk7KzxyBzfaQuKGxoJpjV
 VfzYnaJ5
 UADwBtfIvzL8UkzwUmz7UaShi0Mv7zFjMd3atfiBdknDtfMLrhabEcOPu01GR1lvd6YztAP976DmPrlWXdyQ2WalU6bwDr1sKsCJaOTnVEvmvwGlELY4oCyFif0tFEhSCtl2xQROudeK8kbntyZYnNwDzIiedKs/Va8hQo4RxSLPRaJBL6OKObhGMhxCN7pJAEUwW+x2j705CWxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> commit a914785f6349da754e1226420bf4e51961956769 upstream.

a914785f6349 ("selftests/mm: hugetlb-mremap: add setup of HugeTLB pages") is
Mike's commit, but this patch has you as the author with only your
Signed-off-by. Could you send a v2 that keeps Mike as the author with his
Signed-off-by, followed by yours, or otherwise makes the provenance explicit?

The same applies to the 6.18.y v2.

-- 
Thanks,
Sasha

