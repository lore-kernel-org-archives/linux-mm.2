Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B26A4C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 01:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B986B007B; Fri, 31 Jul 2026 21:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C5A6B0092; Fri, 31 Jul 2026 21:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BA26B0093; Fri, 31 Jul 2026 21:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75F9C6B007B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:05:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06A9AA0200
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 01:05:53 +0000 (UTC)
X-FDA: 85050908586.02.8791880
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 670FA140005
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 01:05:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dDuEkf/F";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785546351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VAJZbyNUfhyoj+kZLuLaGKUMKkAcY5Z2H2mp/fUPHIY=;
	b=tfI3wprGgCczOG9dX65Uu/UIeTDI7/amJRI+SUBLlQiQaCJLLp8GYBXYNI4XyNIqAmStSF
	p9nBrNDmaYeKYrjRzMtRg6jEjbE71YLxl3c2y8UERscmnXAPqYgyDiuw0ldLEtx2GQv/UG
	gSEraAZWfR3dBlsqtM8Zjys27LkC9Tc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785546351;
	b=xA9NoJW9lGYsJI3Ji4DEaw62cCr0sxJ7oyHKZ8l8QolSP3/2FTke0OEgVAQB1zMp3NHI2Z
	9NM1mT9+PBW+kRXe3O7rUmXnaBVbRqXVH8+wZbf1LR99eqL3REImUAt7u+z+X89bYV8AH6
	B/LcylWUJ9CGfZ1WR5X/5VrcHqPlQiU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dDuEkf/F";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 742CC405A9;
	Sat,  1 Aug 2026 01:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA341F00AC4;
	Sat,  1 Aug 2026 01:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785546350;
	bh=VAJZbyNUfhyoj+kZLuLaGKUMKkAcY5Z2H2mp/fUPHIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDuEkf/FVc7XlKopgPiJDBobTv2cN0JECX21hgtc5AmKIHElhOh1Xv3KV9ezbhJBO
	 thGg9d373RhfVnvdVOJ1KBFX9v1D9QvEsaijz4YmOisAMwXh2DGRMsosrlJQ11zFms
	 qYSpdBPUeVCm3OcAkSctn43s/pqi4qv6tfwlQlZ887ff1hx7h5rnT8OdflRLbSjRke
	 sqedEJxgz61jY+SgoDXxdfqpr8jUuG+9oOpoC+QWsmEPjp4qtLY+ozGZ4ibCP66W8O
	 8rHpcxsnBhjCVuZYDnkDf/oZ7apox7XylfbfAPim5ohHTpLoHm/twVPAOZGcCIDzRe
	 q1NXeBUKiW2vQ==
From: SJ Park <sj@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/mm: add thp_swap_allocator_test to .gitignore
Date: Fri, 31 Jul 2026 18:05:41 -0700
Message-ID: <20260801010542.85345-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731070343.83837-1-sarthak.sharma@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y39g6p51bhcsmeeetfs83hd77sgmdk56
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 670FA140005
X-HE-Tag: 1785546351-959913
X-HE-Meta: U2FsdGVkX197ZoY2+qcXMbRfTck2gQE4CAY3qqHU5Jkrfmt0qXOi4VpGTsM0Mk+LzVQ7BbylPX2JfTV00XOsrn8dc2dMaURVlFzMtThveNDIho7iGe+2/n5AQ2wJ2v/GOWT928F6I6Re5QmJJoZcTM/IBHNFXuuFJ4Gnmly4I8nnJUgks5AXuwWQwEK8/engq4uV/h2E0weTCE4GEkqcrMTQG775il2bB2yMB78ywkUEVDs1fzHrbKoM047gO+xmzZct5H6NlLqyuLdBgFUSjG1FIivW1gR0p9bFOZa6k76/3SKa/ZTrLTsb5np/2Rraztb7rKuM8IZVnSQNgwzN9CRvwqPlfT4cyXL/EPNOYCoKeMW7feeXU52BmPMxxPTq8pX1IoBlJo9aXpJjqs4iPOkEZQjSViGiY9HxZm5d/la/258BvnvMX9dgwRGwOf+GVBXjNVoS9ZIpJUAcBGfYPw1nyd8t4v3AUZ5hx55RJTST7DBUdnaUhq6BwjJdx9yjRTg8acVYVmbaPvqtk+l+07RN9ntN2aBLJz0JqPqpeSwEPzCevB4/F0uiq4yydGbmYDvg5WdXwtRPnlGM+Mjx4eI/8CneO20YShd/NKbj3YzWip0kkz+TXWWlfwStnr2mI7t/p5Z5uUs1k+iYeBkxiQhLwE/EpwoEA2BSZ/Z8JQiYuS94mpHOp3vVNErN9/44J8SZmZYCto0SSe3onlwg1pcL8k8WRaePWAGfbQLGXfeOUbtOdoT4WunRC0dykX5EuYn82X0ZJK+zJK5iVefNcVidYIg54NfiJS2GnSnfjGxm6Hr1bhsJGa7TR5Ig9xCOlozqXX9njvpQylJURw1eZtYxUSayigrFFmz1GzIVXg45UdRWOUwAwRymQ+/6yqXe1wdK3HjWKesMlcWb3bXfX3iI4e6H+rDxiPwc/TMJNBMHJbKze3WxGRsH1+TfzCjxGSHcxrNodnCNvdhgvsm
 Qvg//lxm
 Ns40+XawYyb16LUFUqkb7qLrJLxmQ6fdCgiCgT8rrgvJyNtuaVubswKooRAGeYMOqFxlUegC96zwzdqokqEn7Q+/OhH9ukP6hv4W5DEZwlfykWg5StvTKTvKzOAEENFJr8fxzhWLReaTzP27BUAIAYrZ/e4lVk94a8+4UOmi3cK8Nmh3/58VHflYPNBBwDGWDmkZfx9N0ZRgNdComDRbLiQK1yDiQQWKF1fxUx0UBB3fRT4xUCGXnjhodqTHlZll4nCQ+vhesxTMxYFJ4LHTze5+HoxPoi6jC3rFDXY5HK1Brqdc/ELWRc8WJ/8FzL2+AY4T9AwgeQ/+O843FSMUx0HggHSXyb7PmObQXPKwYcW8PcuGkxZ2moJVYIT7FvK9C9uuOOCVAZOvQIuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 12:33:43 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:

> .gitignore currently does not include the binary
> thp_swap_allocator_test. Add it to .gitignore.

Thank you, but it seems the same change is already in mm.git.

[1] https://lore.kernel.org/20260624150642.19749-1-zenghui.yu@linux.dev


Thanks,
SJ

[...]

