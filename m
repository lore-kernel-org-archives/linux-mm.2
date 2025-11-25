Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC6BD0E6C5
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 11:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF376B002D; Tue, 25 Nov 2025 06:09:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97866B002F; Tue, 25 Nov 2025 06:09:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4016B0030; Tue, 25 Nov 2025 06:09:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA0DB6B002D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 06:09:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 71C381A069B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:09:25 +0000 (UTC)
X-FDA: 84148858290.28.8952986
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id EC7901A0008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:09:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RL/Otnym";
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764068964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Wm+6M8LDE0X+0+aQHbYJCdauf2zkPM73itF+MPmgtrY=;
	b=xikqW/hHoy5LpAQpHiTNKzBsLxC5wA+qSoBTA9DGhCqXIWOJL2LJrn73UR91ZOlxmweb7t
	/z9nMfQVvDdUWiQuhcvvUhdVu9ltgFvdobffdYyof6co80zSrA6jc8Cwk5hulfzFD5XPaj
	tm1NmzAAMgV/++qJV7KlJJ0rgqnFZSI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764068964; a=rsa-sha256;
	cv=none;
	b=8Ne/1Vse0ZEYU3Z+GsGCPO599jgm0J5GWuirImZRe21D1jBhxNPPNEM7l5G4l3arwwoDaH
	YhJaradVN9EqdY88cpqm3pTAv/Zg7EjXTH2GJiY5xc/u2jr9pdVzcbJSCAkhpytRrSx+Vb
	6+ukmfok6P0AmeHuurPcaVrAKhXYaZs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RL/Otnym";
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FD1E60007;
	Tue, 25 Nov 2025 11:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE54CC4CEF1;
	Tue, 25 Nov 2025 11:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764068963;
	bh=4DYDMnA92UpIobCeJ2W3qbFQ8fEUSrxC8a7VpGT6HT8=;
	h=From:To:Cc:Subject:Date:From;
	b=RL/OtnymtiOv/8oA1itc+piZB+wYOpkgu3xLOj1e7E8nx80Cp+tgIlY4xyPnfY4Jz
	 9GK+D/XjhmJvMRg/XywuiWp8uN6EXr5xDsRbDuFtyl45ebV5zXU3IuyNHHH48UOMsr
	 NU+an4nUvUZ7i/mOBwYE76K13vWxU1OzjZtqnwk4E4Fu5svDQUcj0UTEZl7Snq14Vo
	 idyLYUbEZqZs6cjowTbN8VunrI+7/83feOGnTwfqs/tyB/XHj3jQAlZYC3g03Mtxf9
	 Gt8nuwURHbjepkEiXrB3XDeEIDOefYTRDSpTUxXiC/ujRloxwi8lLgdAbXSJ5XKP2m
	 3F+OM4y/2lu0g==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] kho: fixes for vmalloc restoration
Date: Tue, 25 Nov 2025 13:09:15 +0200
Message-ID: <20251125110917.843744-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rxk38rfw6opz1p9y1tgrbkof77zukres
X-Rspam-User: 
X-Rspamd-Queue-Id: EC7901A0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1764068963-455314
X-HE-Meta: U2FsdGVkX1+3UhYhjPHVVOExBjbGaKDSUmP4dw7rx+JuSMH8DTn54lIk3mgAGXv0GZUmfc09yRJEpf/T8enfknVyauN/2FFawFKGCqs+/i0kazIb5apQAIbLONbQ6/q8DXmnKvWdgWwTwzT0UX1ZGdeSu6n5mo2HAFvlL3bykN4rvCLvUyS1bX2QpSjzq+7yVDgrNyUf36G8b22ZonTRlKjJe8+yawhnPT/K9u2kkG5rImsam8Tepwoe7gzgv7d/HDPGcvjGH34WtFQC90fhrgn38I6eZ00Lum6fKwgoSjeGXpDF1ELnePxrOeXWqRm66Ty3mztrt4TLFlLi+qxvyQH9dzzCCwWBdmQMjDz9Ai2rx9ukErbOtQmUoPI4ZDnSOY6r5vekw7k6dIt7mUqZ+x9vvHn/SBIoOrC0hDCfjZvuV8wV4IhMX8sSFhNPMZZLJ5uKK4EygFLdSu67TKhIBfmBzB9+AmaT7eEw0c0ViFcxQL1gldIB07qOxHGvcPLvnCBiq3iH9sPxqL3YqCtJwCsczoIrrFMQWumYAMj9zfhH1Grk2Ky1ltRW7X4uoRV8DJHcDQGAvkjoE4RiJ4GRrX1/WzSYQJJoKGzuiVS06pYUZ7x9Luf80T8hCOlhqZM3fs29buEzx6JCo19eiRNTvXJVTWUAWECgWOz+EalUjc8OOcl8xthKGFMyXIsAkwmCp24SeYbkXlcymiXhDWhjC+AYUM+uOiG16Cr4IVxAM6I7atarIca1tY9VoQCuJdJz91/s+Uivmjhm6ZO+Q9D/Ki2htBx0DTzUOXwT17mv98tdCOK+ikOSteATL2EjLdtNYN3A6eUjTgELYaz6a0ZVd9li7GAOlBxbEOtdIGPaajhIXqnKlAdcZ41nPHAHG3lRyxiiAZHVjRWBarLFtlZGKwnc4BwE7ADURcXl3fVMGji7X/QqJhMx8YARlif5H/+mns8f3cGMUB7UnV2XjtB
 sj6x/Q7W
 Kl8JYQ2yr1UfJarYRBzP5cr4tiq4VjXm/WABCMvId2VpanmxbHIk2J4puyDMI3UU38sTFrOMd2LSaZSTdgoetGiryJTl4bYrCcFEysiqrVO/e1u0SskA8kTiZu8M++gVphLAPyAMQmrxaJQfk16a/vetVvOxb5LQqbrXG635RE3cMN9e2E2eysuIG5qVRehr25hH5ySxKCxTs3NIYhfkXOP9tgKdX8g7nd8KuDLPerRrlNT8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

Pratyush reported off-list that when kho_restore_vmalloc() is used to
restore a vmalloc_huge() allocation it hits VM_BUG_ON() when we reconstruct
the struct pages in kho_restore_pages().

These patches fix the issue.

Mike Rapoport (Microsoft) (2):
  kho: kho_restore_vmalloc: fix initialization of pages array
  kho: fix restoring of contiguous ranges of order-0 pages

 kernel/liveupdate/kexec_handover.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

-- 
2.50.1


