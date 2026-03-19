Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 012911088E76
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5606B03E3; Thu, 19 Mar 2026 01:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2430D6B03E4; Thu, 19 Mar 2026 01:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03246B03E6; Thu, 19 Mar 2026 01:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE8156B03E0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:22:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 819C51B7A84
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:10 +0000 (UTC)
X-FDA: 84561666420.18.A3CE728
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D7C08160008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B3czYL5V;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773897729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZPhaHowCOZTXjwVi3vT5DWxi36HulpeZo24DtLe2ko=;
	b=bHvaPpXGCnMukyngfpMhS/TGIERMnyISubAEcjceAS87O+ONNroJCyRCwiBWCOO1au8H42
	qXPHK9gNBCInuPsFl+EQZlYXwOqlFHJ4pK8EkpEDrzbI4wPs5kdIkvAXTeHunYMxmQ9tK4
	LzJMYo8zshL8w9xF51CBYVuxHPkm+ZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773897729; a=rsa-sha256;
	cv=none;
	b=J/vmXJRJnroHISAZUBjm3sN12C+HLLfutvkmP9cjsSzWeUBh4CXQGDWl+b49rQxMGmUOrq
	FpybKKAaJrFiUmP0w+PEROZrHGl1uGI3dhQhQaqg7NMKGP582DVuXFsyV5FQcnIwnvVwzy
	4JTkT/Nt13XydU3vCGceirWM3/lP4dY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B3czYL5V;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1449D44454;
	Thu, 19 Mar 2026 05:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83E3C2BC9E;
	Thu, 19 Mar 2026 05:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773897728;
	bh=Xzm+JNkj3Yeb12esLxd9yBTp5fRgZ5ByNKV19KwHmDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3czYL5VHrXtOTWvqFJCV/UmAYYYkP5VakJDq+d/YxslDrCYDJlErt4+uYhXOc1Hl
	 TeWisEWjP1O4bcNYk127D7J9mPz+gtVQFJIpUlNp5vcKGWBLdp91ACjVT4SSAoJ+Tl
	 bYSyUyoFVN2m5GqYnhIi+oGlVnWZqcrw7EWhgG6DfA9q6fUJxUtQv6DYA8/cxjWUcE
	 5w1tl8xpr5WAfr7iDajp1UAiQkSHM48IgvbjropwwwfHE3LwvutLp2ESYbDB0G1QCY
	 Ucwc+MJL8Ueesq6q2COj2EJJ++KpObfLLKSVgumgde7H0gS4gfLjg9hAi8vSxhujhA
	 lWEmpYhpinKOw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 03/10] Docs/mm/damon/design: update for context pause/resume feature
Date: Wed, 18 Mar 2026 22:21:46 -0700
Message-ID: <20260319052157.99433-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-1-sj@kernel.org>
References: <20260319052157.99433-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: e8cb4c931s6k7egrf8umwbin1docqkqh
X-Rspamd-Queue-Id: D7C08160008
X-Rspamd-Server: rspam03
X-HE-Tag: 1773897728-293231
X-HE-Meta: U2FsdGVkX1+RJvT5rGx5NQGwR3NJ21A7k0gt4l/vxlEmYFSXdGTeO2sfHqJk1uqHMVPsTbMX5/YXkB7Yuzd3L4bBSq4UE1e2yKTBNnSCi9G0M9vuRITflHEWLEKJNpqviiCjtDd3OHxHCeP7ZfIPyurB6u+aJSy95Td1x5OXl1IaRgr/HN2aSN+pl/bSPuXcIm7mgTtrx8aZvdvXIcjbHm39u3Cq22AsY5tqslZU5IoJb980dp62glMdxUERrHXWThg8B6pMsdJ898SLXBj6riXM8Vo6tug/SaxnUbhS8Vgq2AJqqqqsGDWB9qSGi3nDo+iNn0p7U5BAvxbwrOTguAxn9SIGkiy4+3/VBD37mB8heUaFrilz7RlAWd34IbnozzuQVwp+yNyd23Wk9ci9HleWXyD8lGvjAxA6hI5eCS+M3YkdM1RXZp3P6EtLYlMvv81IQU6i7MYOLvgRAL2qXphuZPnQPR8JH/EzDtTNETYk2EbPEnQfmp+O6qBEM7QZeVIWToeLm3431j9uMI/Epd4AzOe/PnuCFEL6nCSk5Cz1L5o7QLnSpIRKj7H5Js+Ue2LenGbNpjK87quACF2MHmd+SIfnqtlnfLdhfIyy5eCql83NxrS8vO+AR8H4nZtWhA9Q33vUrOxbuZMAmHv4vC/ZRmeU1YQvbPRyYZiFZLMr0vBuiub1u+LJg51LGUo6xYGWnnRZWnTTMigjiTFzlTtGbhP5kxaJMLpoyQhEd/ZEv/S9R6G3CfxXmgIQZ3vGJMDnCeSe7LUAIExKY/Qb5RErybidMQDIFWgHL3m/NMxytrSTdCIRRs6vSu7AFPxIa0nA/qKPEKY+Oh8JGMpIbLf15GMWMgmgPzp9QsoKiVlA1lLwf5Gw3GV16KqIVT4BvKC1DvYrm/neEMYVTTNr2rNfvpQcLfgLDRfIAAa8ylGBM3OhbzDNgpKYXb9CGZaMdCfkTZUXFRdwnDSSh7m
 QAWBLAlw
 MMKtGk4/mVYc68Fal2fvvRmhJ5Mbpqlrfb8VxBZgPJMX9bg97t/fXeLFU6GYhso8UhD44Nfd78CtpIV3V0Jti2Kf2l+5tKBsqyDPGFgEShDiF4z9Jjx2e9TtiZGmLXyBU1kcUkG7+R0t5M7IrBHZdJwJW1+U0nPx9gXFYRVBC24mH7oYv1HHZp176LmRalTLQVKV99i1yuP5Jjrxpb6gLBNxZGX7KRnhQJDZRHhBYzcMGx/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 838b14d225193..e2e4fe3fb3986 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -19,6 +19,13 @@ types of monitoring.
 To know how user-space can do the configurations and start/stop DAMON, refer to
 :ref:`DAMON sysfs interface <sysfs_interface>` documentation.
 
+Users can also request each context execution to be paused and resumed.  When
+it is paused, the kdamond does nothing but only online parameters updates
+including resume request handling.
+
+To know how user-space can pause/resume each context, refer to :ref:`DAMON
+sysfs context <sysfs_context>` usage documentation.
+
 
 Overall Architecture
 ====================
-- 
2.47.3

