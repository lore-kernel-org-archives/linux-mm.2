Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F2C606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KR3A9L0V
Received: by kanga.kvack.org (Postfix)
	id A91BF6B05B1; Thu, 26 Nov 2026 07:39:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42366B05B2; Thu, 26 Nov 2026 07:39:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980146B05B3; Thu, 26 Nov 2026 07:39:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7798A6B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:39:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB449C041E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:39:53 +0000 (UTC)
X-FDA: 85477227066.25.4639D07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 28EDD80008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:39:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KR3A9L0V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795696792;
	b=SpmEeexPeCEgwtbNdEpng58za49ysC4oYj8ZnPHv+8zXYtxXSAdu+ozNMa2xZmgFT2n/nB
	VwtvLg5KWxmgFPBIkeUk91LMAzYczMWQlsmCNGFriUFSdHztYJkjiQXwEzSi4A92iY8xni
	XJz7wr1s52yCNy1P+4L1hBUS1k0gfAQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795696792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3Vrgu8a6DhnD5x0zdlXCxiwJd6p3spzYZMPi3rDJIo=;
	b=XHO7S8uSSfJw8ofayOLmQ1+7yMMHIGPBeSIiYWLUvW+lbX8fohqhvPjldW9s35U/HsjFla
	snaea2OJSuiEnQi6kyguGWKOG7G3BKB8DmzZHn4OF2ddgtIq0ONsCu73FAYqIeUa765Qq9
	Qpk1Y2or2+pkxe6GP4VjUtyIubw9KTc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KR3A9L0V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5693E41878;
	Thu, 26 Nov 2026 12:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37BB1F000C0;
	Thu, 26 Nov 2026 12:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795696791;
	bh=e3Vrgu8a6DhnD5x0zdlXCxiwJd6p3spzYZMPi3rDJIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KR3A9L0VZpKALooXFfJGBXBBHfYTm+/7kiZ8wlFcFuRXBWdBSbnZOIZVH5T6CHoa1
	 9io65Zms5anLjDPNI76lA/eFbZj5ZGRqdJdpqC9TyvMzMB/fNJBbFapBfnofiJnIq5
	 e82/+f61DkNp9WkroWudGo633awrt70wUvlcYtrrJrUDJcEVVNcrtwoSnnJJYMRGDq
	 8d4zS0k+WKA333Hr5nZmKhucdABm68ygQr1qNDIJ/D3bCD5ztXi7vnOGIU3bgnIcjq
	 idFd3omvBztPAhx5ho29H3sQ5Hs9PFSXYLejD40KvsxrHJ/TRjG2i2AOUwuYP4l2sR
	 ABJLoA2w3siAQ==
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Chris Down <chris@chrisdown.name>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/2] memfd_luo: keep memfd frozen until finish
Date: Thu, 26 Nov 2026 14:39:44 +0200
Message-ID: <179569676808.4123145.16669613485216005083.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123130509.4032642-1-pratyush@kernel.org>
References: <20261123130509.4032642-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 28EDD80008
X-Stat-Signature: wp74634m168azw7jxkgzd5ziunsue8xa
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795696791-18224
X-HE-Meta: U2FsdGVkX1/M9KH/xOvG+RrM+EIB85JP15hEStIeb0PInGtwMqXEzDYbN7U+8AIgLaPoXTEbOINqLirryP9YJu3Bl5UjrjzDKAVc+lPttVsd6e4O6VhhW+Js84yuWrqx8VOIGo6yJmr72CoryL1eWcl888PZAKCX8Na1eBzhop+4TOpOL3t4rqXJAmLYgPZL02WjEFTtYpxv7saMbLlopfSX2WkLTESOl+Kw8bNqqXYFwW/WIvnHkk1FBqxv1GT0xp3onE29v5oHgBrWHlrug9lI3xaJ+xHwuRcOvRziik8TDAD0VQTWf6O7uKzXIFVgql120K12ZNPUCydZ6Ysi/xSXMFWhZoD+8W7v6dEMHxjrCkIWnGfBIv/Hc/078r6FU5DbIL4A2OkB/dRLqcBXrVkhObv+zOEKRsiIxT5bGWrXmB6vAPJqom4EP4M+adAcGtkVZPT2wxICjzhzXXwaODk+e0ntjF/Z2BdvKwVERzMboUE9ADnY355mM1cT+muFbVw8IiTTkx1oQ7oc7SxET9Cuj0N5rMW8o8jq+T2eXwlkmKYgCwSIsHR36njzJklZabxwNpaMiPuHd0/mEpeovkfO58nT+OmTjMzocwFJ9pH+vCMmSjBR4LsjjDFe+YIY78T53xYq3BZa5Aslxm1FR0iKqyu5ZAvbUw1mIKGJ+pcic6cCkpBsTXz2ktx99rsTNwNB1RVHOcjF9xyr3UUOLsj8svvNcHs4BXpR3MtzO+G+lpcj2iq3F+hB1xIdLmPJWYqa1oJYtUZc/RazQEFNh1nDlewRWxXm0zHxQKLAD36u/d5nm0WJImHAhanWtbNCyhGsY1AtPeIWNwn8EyXaY3If/9O05fT7GXm70IkOK+9WgZdeiKAvbhoxqFc/0RbtwA8WYVkMOkkpdrtkY7P8qY+mmCIv8fk931EEwsd+fs0B0M8fQILgcCp2OhhohIy3Z1nZ8ASYAfUdPwZ4nlA
 07sAC6lg
 jnFWRO3CXC0K6mUg3KEvO4pcDkz1D9oJ2EtsflVDPj2ADq7N7C6blsEWZkZ6HTezPRjzDtm7hp7FMDPBEUUkqeXifO7Dc2RFt/wRWFyAmQtr5bNZWi8bW0yw0Vd2vl1tacx01my4nI6hY/Qg5pV+IUsK2/clU/Tp3YSRn7DLBeNpfohC7IjXGLWP+Ht6HFtZJIW/AQ9GasyeFdlZctcqFa0BFj68+7krS1v8DGxRinzQ7U6dEyvzupIK5Mpiqpn/FzzUbM/KhkOW3jeTBFXtCfy/VgAaeFuaty1w67VUA2A6yHwRMz6qmdIIwWosyZrorAcoKw/vrW2GPMzogs5SJ38iyAc042YZC/sKf2l5OkxM9x43It6+ACKFi3MFxGNq5nFnmbVUOZxZZfUUfKdyTFJCLmI/dl5DBC3+IIkVLkyMYzx9ot05VexWMwSTB3Gtdj3s2u8BmDV5XSrtpu9WgWjaXOhWhRTYo7MPlTX0AsRuDgSf49183H5FL4CyOcLb/z+dwZmwXpYxBV8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Mon, 23 Nov 2026 13:05:06 +0000, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Hi,
> 
> This series keeps a retrieved memfd frozen until finish. The main
> motivation is to let dependents like iommufd have a chance to acquire a
> reference. It also fits conceptually: finish is the point when the file
> should be back to "normal".
> 
> [...]

Applied to next branch of liveupdate/linux.git tree, thanks!

[1/2] liveupdate: luo_file: allow keeping private_data from retrieve until finish
      commit: 407c72e5a9c329e169c5132557c905913116f04d
[2/2] mm/memfd_luo: keep memfd frozen until finish
      commit: a89b83c7a9571dacb10e757d9a7400a886b11bc8

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: next

--
Sincerely yours,
Mike.


