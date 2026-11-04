Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A54A4606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RI03ExhV
Received: by kanga.kvack.org (Postfix)
	id BA58A6B05B3; Wed,  4 Nov 2026 04:20:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55E46B05B7; Wed,  4 Nov 2026 04:20:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93E76B05C3; Wed,  4 Nov 2026 04:20:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 917176B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:20:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A2EA404AC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:20:22 +0000 (UTC)
X-FDA: 85396890684.13.3FF6BD3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8A3D1100009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:20:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RI03ExhV;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqLsI51xXE9XvqQwrewS8kVZYOVybuvhFSYA9nKiQ5w=;
	b=iqWJUQBnj0Vnmg+Cx0DpwMSNuZU6PtAscJblRtkQ9zl1bzn0gTA9OsrEJqNYsrX7ZueNlt
	wp2bjlRs/+SDa2mJxz6+iYO9DMsITpBZhZm4FVz40PALCwrhlWcfuQ8KrYmQniSVBvHoz+
	oWJ0Xj1F8Y5+BsUWpyfn0bYGJW+haNE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784020;
	b=rP6AE5zEYAXolQ7QgJZ83fcaxlvtPGB3jT6IcFXQJwJyJELgBX/4t3gV7lmmHcyXqgWFQ8
	1GEHBDJ40ecaEUpvIHd5NLGRQw098bLkGtmHUBaXxQdypB0F5+bjP+3EPmxnLICyOod3lA
	132ofuxsfCBrZRpfhhTpk8+5lhZkkbI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RI03ExhV;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEECD4022E;
	Wed,  4 Nov 2026 09:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14201F000C1;
	Wed,  4 Nov 2026 09:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784019;
	bh=BqLsI51xXE9XvqQwrewS8kVZYOVybuvhFSYA9nKiQ5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RI03ExhVHW+vXW50GI/z1t5fOv/JldWAfo3PTbpnjtH9ZHo58Lc2AcPxXJ5PtbXAX
	 8g4KSTO5fOZQCtpyjjL/bJvrwiezCM9YEtZIA/HFUZUjXdYaQqcpF0TeHFBMUlhQKU
	 cwV4vnKJXipMsVWc69bizj8nAauOCKTGcIiZij9G7eWxZ3rmj4e0CBFYHzcKtXnQSl
	 AJB/iwP2dB6oj6qGqoWsBFGeMkJxlpj4mX3YlYJ3ZSSJ9f+IEjQkqzGNq+iWXf8V9P
	 ITxx8RHhN/lsRkk2i0dJRQVWI5FBwtmizQ/MBQbxSu+48ni+gfhGCNjOwQDZHYMP7B
	 rmF7LwmTvp1Aw==
Date: Wed, 4 Nov 2026 10:20:07 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, 
	linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-modules@vger.kernel.org, Chuck Lever <cel@kernel.org>, tytso@mit.edu, 
	dmitry.torokhov@gmail.com, Petr Pavlu <petr.pavlu@suse.com>, 
	Anna Schumaker <anna@kernel.org>, yukuai@fygo.io, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH RFC 35/38] proc: sysctl: don't hold the tables while
 readdir copies to userspace
Message-ID: <20261104-getreide-fallpauschalen-uralt-d366f2bf03b0@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-35-59422ed3e465@kernel.org>
 <sashiko-outbox-195507@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-195507@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: f4z3ftp65jxna6aa8osugtd3y5kk68z3
X-Rspamd-Queue-Id: 8A3D1100009
X-Rspam-User: 
X-HE-Tag: 1793784020-520831
X-HE-Meta: U2FsdGVkX1+7KuKimQOq17VdMWSlKtm3GMhniycgoQxK3cFBR787op8rZ3gL5VxjLMzkw5L6t7eqax4f8DqD1Tl1Gmvlpwcj4fVLwePo7rXvvtFH/bmdE6rrRbMwLxSp1pUpmQzOuKqvMkfGqJLGE/wa8gdnkePc2rBF5g78Jsr5F0BNIAxhKoYxbFefhORWbFEXz5RltSZf3zW2VEECz8CQ1GGmCMXAKjybdkTS9XXx1lyavjrV412y+OU+QyY9wliV1jPxGTAeLi2RyMYwEa0dpV2wnOT+U9kJBx2Arznh/zRAuBbD8lInNu6MGdx8q9QnDQzvf5c4oHBcZ1ok807bJ+PmN7g35eSmjaTEaTnAbFSP/NqUg6+hZw1E1BnlEMwBXmnDoyjBcZ+JCm4pEK3ZdNmQf7qd0RPq8de35STJ493myVpf8gECo7OPGOMJFUkWr1OlI/WF2b0ErFcfhMDsc7WjoBZr8mJrOtwZDULkBs8gGK4/1GFo7nIT7nadfHiejvkGFpwv85/Un+MhhXHKxyKtqPCVDc4e1x3LwXVU3saXbsqJX6nxpT3JuGMJSBq1o7pMMGXxD2PmUxDeQx2Ev4DkIzqlxrzShkmi2+ImXuFr2fxlLbtWtAEZNpIP3TxEID0EsfT9OcRicoRPhUFFbdrHpX/vYupRUxXt2ORmNyIsehw3RMTnzKJ5+C3BLVzcK94+wRY0sAZfLce7SDgTAPFc8VC+BKw0fPCPsHufNfX5zaTrcjMiNnlpMYx7qmLrf5+eQFQ5NVFf4mEmwZ6bZlJDFQx2C1lmw8ORmM9A8arwnWuXKCXFr0TnRTAaFFfx6dmX7pY2NECzN92/XYlwoVE/Vv6pywOKeQln2VdU5iZ+aL1B+l6U33JDiA8ADI27Q9TQOw8W78qeidv69wVcu2ooaLhPQqNOEYV3hfob55t44/L7uZNe+ewy8xvbR58QHI6khBbErGzJktp
 yZcHLsNr
 qn3Qik3GYiyoSOOK+CjOfwAZVZkmhpIIovSmxchaf0TzmWzyBpPY+tNqdGtzuik+d5weooMpCr/UW4vv1Eqkz8uvq1O+Wruv1DSYbkBlqSVzP7uipxrnZi1LvtVKdcOBZV+hcSS2mLfa61w5YL7IME+d4daedIzrXsJQLhzIO+AsWBGQn+MnCvb2Y8b5gXMkguS0BspSXOcDXvNhy67VqVvPj4KN6e5wpdbzGD98uKOoRZZqXql6yYI7l15NNVMwtUZBPkhOa7l0bZ7GonPg9CqSPhiPeSzxGe7PMnayRbYgmmt+Ze8+lh/+4NR0fbm/Nvf5G5NC4/pDH/62bDyvyu7MvdH8TCJg57EBgybdLl/0R8DzJo5gbq5w1C17LN2xwipPsAw/9z8GW96vQerD0PUattw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 02:48:38PM +0000, sashiko-bot@kernel.org wrote:
> - [Medium] proc: sysctl: premature EOF and lost errors in proc_sys_readdir()

This is pre-existing. proc_sys_make_inode() refuses a table that is
being unregistered since ace0c791e6c3 ("proc/sysctl: Don't grab i_lock
under sysctl_lock."). The old proc_sys_readdir() stops at an entry the
same way.

We can fix this by skpping the entry.

> - [Low] proc: sysctl: unused mode field in struct sysctl_dirent

Dropped.

-- 

