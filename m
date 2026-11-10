Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4A5606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oC9iFwgo
Received: by kanga.kvack.org (Postfix)
	id 37D106B00EF; Tue, 10 Nov 2026 16:48:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E136B05B0; Tue, 10 Nov 2026 16:48:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 244576B05B1; Tue, 10 Nov 2026 16:48:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08D316B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:48:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B1061C15BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:48:34 +0000 (UTC)
X-FDA: 85420548948.18.348017C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0EE0B100006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:48:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oC9iFwgo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794347313;
	b=kwie0P5ofyfz+Ye5h3jNWQyL6rz2ztOmOpuhxh+6Yr7rvivo62kMXDdQ3/pjnxUGSKHfBy
	LWqpU/F5iZBY5Pyx1h9Zgt0ua0ILNbiDHueLRRwrLF3Zijb8WoWD3VVZCC0uqXhWnh6fnd
	OQLl0hVQ+3BGRenNPQIdSYWX2TXVqcc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794347313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2pPMf68MKLxuySWp5Wno+q1xTo+NPVvk6DAmNFSvFk=;
	b=1bsVDlBd6ZXDbEOI6bev3QBCZJprlhU6KApc/pUq5zNLZju4pF2Yc/MucnpQrFS6l5bKct
	WMXbyLlHxq3U1rZP8la/g45d3lp6QpmezLIpB3TPLOd7boMSJmzYbZMjulM/w1tddz8wGY
	Yc9XTQ+pi4owYHJBjohSJNXYXUTMCh4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oC9iFwgo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DFDA61300;
	Tue, 10 Nov 2026 21:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688451F0089F;
	Tue, 10 Nov 2026 21:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347312;
	bh=S2pPMf68MKLxuySWp5Wno+q1xTo+NPVvk6DAmNFSvFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oC9iFwgoyNF0avpSzP+LujPrHBL55F0iQ1+eh40/xaQGCsUJwyZj2fPS30ujin4Dm
	 SVnQqpZ2SjogMiMYXPEzvfYKJzVMoBv+Df3csdKCA801hOuiWqyDvQl/FCA1PveiKn
	 dlzsj5berdJeLTvrfRf1tn+APYZX4HAekqypgq7yh7KMtnngVzBJ7X+HDQSs3Y/Ves
	 YrQKw6AR2dcxgAuVjhMouKyxBmBPILui/uSJqFha6vIpd35V81aHP3IEK9IhKRSlAC
	 hI/LC3SWGPGbDDIpo82LOorhqYu1cfTQEirY6vqyc6wT1nSwBig0OETsSsx225pPq2
	 gh4ZaFXCqLkVQ==
Date: Tue, 10 Nov 2026 22:48:26 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 03/34] fs: add a generic emergency read-only state
Message-ID: <20261110-person-fischen-gutmachen-7b04d2256799@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-3-2f44f64f0b66@kernel.org>
 <gm5ays7o5ps2gcokxw6giymwwalixk6dychwlqfgx4brjohfth@cyrrjbycqjnj>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <gm5ays7o5ps2gcokxw6giymwwalixk6dychwlqfgx4brjohfth@cyrrjbycqjnj>
X-Rspamd-Queue-Id: 0EE0B100006
X-Rspamd-Server: rspam12
X-Stat-Signature: u3cfrm8kxdor8b46m3kstucfe9xhbga8
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794347312-808649
X-HE-Meta: U2FsdGVkX19VnGri79BFFKorFp7SMF9TRnNGU89QuDnKCtSxaDV3IYfLSg04/lV2FF1VdqjZxZR4UYXGjOL6V3cMtUsGTwpiZGrDUbuMEbdJ0bgpp8BP7AUXhxzVHCh36XbCuKAcfkR0rwYWjhjXukGHu2Dxz/np0G4qB7mKRas7Q9vZsFQUOx8tyWIqPMAt5By856nVBD3lMM9WCatuI+s8CxzQaL9Zh9ueugG9C6kFxUcMWhV1IZVuutafneNQ8vbcAu2RFpW4f6AVa8glOBdLYu6qD8gXWImf7npa1eaDrNEfqTWd9XpnYmhve6rHMfP6TzT0DE2tZ/ollHmLk/LP0fBsmm0QoKU06JynusNKfvg9ookCphrifBb01BVWlMFdIunfN8uZ0BaM2J3rBtiIrhu4ntN5gYjyZpwGb8b2S9O3P+ac243ZtkQyRjpZ2gnM2soS8+Nu/py1l+/38jIudW0HNAVP62aqGtYUJyyRM9wV12vkWYT5ovMYkI/n6bsBQCpIoEiDIbfKTxYr1WwvGraIU99ZwlPIQjIxaxSWPLT86G6xvfh0Zg8ITv8MIw/bhv2gRJEMxcWpTnqpXPBWefkl/D2rUIU5TIn03NEcNYrnhBW2a43GFI/UqLDa1X7IKaVi9VGJN/9c6jqKDYjrjfpQ3AB4XCuZEkP5jUp0wLvz7HQbukOW09yWXv2dIZkw+14iiZ/UwRNB4A+I2frQIQt/kVUEDfcH8bLSosQKIMeRPo5iRZdEKFBvHDmuGQ1LuhWDK/dMgDS4Lyxb4IpHmU+WAJ4ISYN7kJXYeLpiWO6EucAdBS5piG3WsymanCjukpN/+hD5+ro+GfuXH3S+sZZI6TFXhVz8UL1QCkbWOAFFziVPnzT0IJAUhXuWB7emBsb5xvWN9r+uJmtH2AYFH3YkObfkW8IXvQZxyhm3jXWXll/4N/lYXEU7ivCaccqM1HKVwGbkCLOLaKD
 1ESnhavE
 GcJbyobHDXOjrJ2Dz3NqtypogeMw7yZRf1FEDxFRzKC0iF0C0tSGPMrusIFPNZcC3c+H4GJgBGPtcdq0Z7/y5Bo/U2kGRY7uMzheRD2V8tkWXZb/46inVfxu7RlNjOSCxYgThk0HCGE2vcBq5Pr99TsN+EUO2jqazwXEVNl6cYobGLio23vOmMMBIFDehBHitPMrE2kAOvBBJtk+C4gzopv/86TZXpLxaQpEqhNbdZe1fut7CkKLT/z6XrzIxRZUzc0O1l4S9mACbZLb1kXVdlcE3mNzhdfQIKLGFZTjGgIFJrcUx9HBi8iCxO04cjsiUTnQvpOHSWBqe1iU2cernfeC800p+//5TFvxERMUaH74mBHVip1HXVZ0xrUITvUa/2AoNsh5M6k8dlvzHe/t3GsUBg/u4LDa8rH7LyizLx2MVTpPTdrlb6FS794WBYWpZ7ZaDhMjYxA7Gja9Pc1rQSAvk8mylatfbEMj5FrSJ66maTGvnfWoXVGBgSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 10:00:02AM +0100, Jan Kara wrote:
> Maybe it would be good to mention here that anything that goes through
> mnt_want_write_file() or mnt_get_write_access() is treated by these changes
> as well (due to the __mnt_is_readonly() change).

Agreed.

