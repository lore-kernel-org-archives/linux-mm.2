Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6DD1606A335
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JVycrJem
Received: by kanga.kvack.org (Postfix)
	id E8E936B05BD; Tue, 10 Nov 2026 17:00:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65696B05BE; Tue, 10 Nov 2026 17:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA31B6B05BF; Tue, 10 Nov 2026 17:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B915D6B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:00:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F653A014D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:00:08 +0000 (UTC)
X-FDA: 85420578096.06.E23EA63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5F55C1C000D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:00:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JVycrJem;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794348006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSi1Cem5uo/nHM5eotKecOrdsXKahxKBDl5fLDSMhvk=;
	b=EdIiXSGksKMFXwiHJLG+JDVx7bhKhlYYBn2zDaoZD/iP3RiasEhUQFnTo18NZp9WLatr5Z
	t9zB2qTqS3OnWdc6Iz/NB0tcuzi6bVq3oPzQAV0Uc+yjD2uIAfjg8woa8xSihkTKF9QT0i
	6zPRXJWaoDW7eZj31UNZT3nHKGR3iDA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794348006;
	b=i7j70alepEbOkhHdeRRcOWfy5nQUIGdz6BbG5lBseBOjklJ0qoTjZfpvtgf5sz/PPtiW7G
	inXsYOnzXUrIU0iVTKCsZIttBdLU5eVo5shpt46J2sl3obcS1uvoU+wCXcaAzWJZRsXgBm
	vcY3MbZbZ5Mu25cdDFsZ3RRzOEzninQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JVycrJem;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E3E8C637BD;
	Tue, 10 Nov 2026 22:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA391F0089F;
	Tue, 10 Nov 2026 22:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794348005;
	bh=gSi1Cem5uo/nHM5eotKecOrdsXKahxKBDl5fLDSMhvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JVycrJemQMYteTNBsZxUIffQQQPnmrdfGKeARGla+1IErQkChKMhQGOQqlFsfFuhx
	 iwIJoL9qUTODeU6AXawH9JQNrAydyCRqIIZbUIV5s97GSGrL10gNf3kHcDT+5OUruy
	 Q4A/l5PfIpgDURJVTAxCGWrV/XmVD6HaFcN4brBwt1NHeMAiye9Wr1IJu70oJjCdtn
	 XPSDMt6ALnAU6hffPYN51LzE3iM3nlgmmW4NNuqk/GDMMyDuPDB0Rj+b81J7Eztgj4
	 4mfjQRZL094u1Ft6gJOZoWL8bPLzEMTw7x7xlRLHKixpz8bS4+KWY7fDcq9FGXfsPL
	 m+JbHKkaOL78A==
Date: Tue, 10 Nov 2026 23:00:00 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 09/34] exfat: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261110-kundgeben-charakter-womit-db0a0035bb5e@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-9-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191228@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191228@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 4qyom9ffmtaxqaitadu4uugy9kwa9xdc
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5F55C1C000D
X-Rspam-User: 
X-HE-Tag: 1794348006-894703
X-HE-Meta: U2FsdGVkX19+ZbP4YajhuSzExLZXBoTkG/HpiGV1avS69iMrlLBYzudn7iWiIXzc9rwAMUlNS6gzCzMhq+0SINSQKjb8k1jbhaFO/d1YeQXerfQzPt7dGC/JOY1sFQhR/xiOqNl3jtQTyt6rtUpboRMlO7AWRBoIoTvQiP0suAIIn5NeG9Dx4VKaXSFj5uMDCaBRM/80Uw3aQ74dRYwFXosNxSmvUrDAQHh6JjsvKNu2UU9V3p6RGs7+tispGgniuqQYERoWPGBiZaaGPhIaKbgMDNc2pqbmve2cFiw81SNAmXfsGozmyLqMJegkUxfUrmxYupWGscCPrKWstgwoUbpLQbXi1v9WhvFQCZCDzq88y+RIKLkIVkC/JBM160odwCeWa8Ol4y5IdKJ89h59vCzrfNgMkbyO7zfBkp8GyhcbYVuuKXq25/2ysGONnRIu9tMXDk086XzDM7I2wtvvOEV+oV+YXSqJo0/CwHpACXAHI16tifW+GVAELk0bdvl9fICgYcBd0CqfqBZuvuJomKqrhtBgGJDi0unMabDwU4bq4JUGRJ2FONTtBOJo8rmQzaNAS147BYicUxQkDwIi3OWnsC+OY7aZMmeI1X2SE7uo869r2Ox9o2gLiWlgOz5pZIU9TZXNWBoIkVMCI/wpo3KS2zPes6Vj7Lhw0L1Dqh5SDaeGCwjCATvi7IXSCxK4kHtGxYtQOEFJgvb5hKqDkbWIYq+VYFxIZ/wX0rwGGJPLwekeSYBIIqfhsx8tO+C9vWOB3P+vxEVYWoEqkzRf1JJuV/PWjsKJpngPe2qTe6sIriYnQrgKDwwnMJRGLWC4KgWZIIY84EH5zjExANBehEi/bxaaDs1IAHETXCIaIElD9TO74NoyEmeW8sgu2BdlZ/sN7K0fent3LB3Yn/i0QmPAQRgyM+Ue/gx++jDjTzRgHdIw3688awQ3gAOuP8AaCx0/AYwq4KxyObxECc2
 KFAty38j
 ZhtSx9ZZn2IUw7rfkEcamFHavtSQU9XnlykIrpj+HowZ8nx6C5C34Yj2FVflWNcPyM5AIem8q+SzsG4Zt9tfi61dFz5nlW0PLdLml1VwoqsExVmFN4N3+yFSFrUOsPsYp/P9q2BceI3fQevvPKVtTF98S5X04gqvDR+B3va+SazM/7dYROECbiDaKtGGzXXAy7RTpSRizfYxuT2sAnw448m/0SufVcQksyha/SVj+N7ZInZf3yNcsHnBNXT4Kb4mATgUwq+LEXTJaFEQEs3uoXEfGHAb0EWPOHYGRYl8sbG+DqjRlswNAdQmeC9WWtCRKJV0WV7t5xgQI8wSDdRqNva1q6unBLkDuYyi6wOJu1Tz54rDEpLsNbUvNpxBdQSP+bvrZy+qnE8Yo3o8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 04:09:55PM +0000, sashiko-bot@kernel.org wrote:
> Can __exfat_truncate() and/or exfat_evict_inode() check
> exfat_emergency_state() to prevent metadata modifications and discards after
> the filesystem enters emergency read-only state?

Pre-existing.

-- 

