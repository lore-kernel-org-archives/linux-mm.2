Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F122FEFCE21
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609E16B0089; Wed,  4 Mar 2026 12:14:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CACC6B008C; Wed,  4 Mar 2026 12:14:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501236B0092; Wed,  4 Mar 2026 12:14:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D18F6B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:14:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0AC728B540
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:14:48 +0000 (UTC)
X-FDA: 84509030256.10.4F0CB90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 471B8C0009
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:14:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pjbnSbMA;
	spf=pass (imf28.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772644486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qCh22I+eR+/QKF6eXYAvRtMfiyczHxENS6tjZBJbiR8=;
	b=uNDJa5NO3fe4O/5//GlqNiTJfiBmTNi+QO26TgZ58t01KSzJAvFbKop19I4+E0CX+5Hu1u
	OCWuR+lxUtdSgQtYJbks130wZxaNDp1eyJ+AE351PYfG7v7JtvsNK/B3jLTadJhE6zp/XF
	VPRCmtb7V8+FCj0A7zAzanlx4C6ZzHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772644486; a=rsa-sha256;
	cv=none;
	b=gF/4iJhamSQzgqjgoTuMjpISbuhNHs/dpUB5TpRLeiKWf2lyV+IwL6cpDn43wuhEymeS9d
	xEvvCGmQXSgLc/6G+EDESuZCHr7wLz+KxPGXESoHRxE1VkXajQ7PLhL/VNcOUZLGk++4t5
	5S3nxVadxVNfPH0entMmU/yy1boxEhY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pjbnSbMA;
	spf=pass (imf28.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 41150431FE;
	Wed,  4 Mar 2026 17:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FF5C4CEF7;
	Wed,  4 Mar 2026 17:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772644485;
	bh=+oJjHKhWCbPsGXjJkJeOe7mOGQ8z0UHZlgUk21mKa4Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pjbnSbMAKSq7Q17bm6gxIzZUe7SLk8mJOqp24lZqrxoZOWP8muu+D8pvHgKzO/Hso
	 zNHz2YA6A/DENMS7RuxzRXMgnfwDqDyUpfQezziy0Ap//qNMbmCNSV+2AFTBx2b/bF
	 lZk3tFRWsnnoD/Y6DPYhMawbyVEPhTQDOytuTLcSbPSdOT0wrluWQScYcD3GTtRMQI
	 beJeqHGOcMDADjjNiJd3unhPCIi9qsX3oV8mYULON20/Lt77KvXsRpnmESYUxw7w+f
	 5qlnayHrNGao6tUV8YGfVEJkmy9Yy7AssjsivktmQADAJIEnUrM70R1Cr5hZccSwEI
	 Lb6PfUTLYABZQ==
Date: Wed, 04 Mar 2026 07:14:43 -1000
Message-ID: <68c1ca1381d1871fff72b211890a64eb@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>, Korenblit@kvack.org,
	Miriam Rachel <miriam.rachel.korenblit@intel.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item
 is active.
In-Reply-To: <de003dc3-3e37-f238-4250-2df16eeb77d6@candelatech.com>
References: <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
 <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
 <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
 <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
 <aadKDCKGHk1Ua-7_@slm.duckdns.org>
 <3303d57a4ea6776dbc66ca72441023f76e6f1234.camel@sipsolutions.net>
 <35a7ebcf-862f-0b3a-a245-c32196a58692@candelatech.com>
 <aadYoaA_JYduCx_S@slm.duckdns.org>
 <de003dc3-3e37-f238-4250-2df16eeb77d6@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspam-User: 
X-Stat-Signature: aqoiopzr73pqhaytafatx9t6b88rd48z
X-Rspamd-Queue-Id: 471B8C0009
X-Rspamd-Server: rspam03
X-HE-Tag: 1772644486-825770
X-HE-Meta: U2FsdGVkX19DCLGthHkjHZgt+tpe9LIoMisb7xGxlFl1W2LDsleQ9TCUfY9MSJA5uNBqwVzrA9H5RptC3PKc6RXxHbRn2V3QGk4tT8TmUW4JePYjmuixkp1MCuOLw7469zHfoCg99rjRt1sgrMNPkGS0Kx8LofThCMt8iijsFGxl9Ns+AUHxvufJMPa+00SHGW8KW3jRkUeF5Xl3Ek9ZQGrVgj8Oao5AD9FM4TwxOJCnwwhaJt5mOjL+bulVR7zxDaR+beLp8TKQkXXd+pxAZr0sPxSRyp0CmJ5ueMLviwhjFp8hQdiYP+iwN/BUAnl7xZjt//YF1fYhtPWnm8pt8uqIoS/dIH8LVjc3sgn4VzOi/n3/GTzEugvgbX6gZTR5Mhb5zpkQ0Zd4eDoGCiwE2ugaIUQBEU0i9Uar596ucDVSLyc3e9LHAAfqLSa3UPz9GDFj6jKRxDJK1JkBXUpCirTBergcwfTFOGdqfHLY39c7/15dvGHhqMw2Mvqn6PjxfUSgDf6T9ohzcEG9uGOvqlx4dUE7OZM/9zzhlDOmXq+hBBVsCBnF+S7tX0yT5oB1VvPWcvpuqGQtAOk0hnHPCRc6ND6/dtAy9r38LdfrBOoW8EgYghZfJKql6AWQJeWgoerAJOOYBJ78GyQU22MtBB5Eq47Z0lh+9uoMpvMZxeC/HD7v/IIMR6uTD4tgKNzMd2zXY0xNm5Cz/XtplxSiAm8Iz57g9MjaNNr2BI6Ouw8HUPIR03vJf/9wnWO1ZsSt3khOSutlCTnVWmrN/pCORWjkOQTAAw8iSZBj0kI1WRt9wK0AA8NjdE5Rxcg49ydOwwv8jT94ZvjczDzzYAtMfYiVm+tmnc4yVRJBMaUx1cQhKKqlaZxUdG/JnZPzOGMr764Z2RBzUaKK7ftISzYoH8Q7tA+34i2kSUQH738cV2RZKaX9M8ejLaZXDCcdzIpBjMR2YX5LZVxEhpdsPSb
 W5k9+2Ss
 4YDuGx5dzM3N2rjksNNBgLmaxi6JS1Ycun7b6kpP4W2u9NUjYR0fZATMJplmFLzT2lcY/HKoOfrjn7BqSJxZePDZ+AdycdEgHxDNhoI6bK/fMi1qd4JXF65qdPjfBNgG9cq/2/fK5eoHK873yD9ET/8JfqLb7dgNJndelfi6Gl6mz2bHJ2vHvgZFlwuwV6xn+Xnz5QRziDEmndy34UvtgpreS43h6BrLm2h2zvH852wbNyn+ZHYkL+snm/rD0XU7MM2DAU8hicqLg+DNUDfdhdN7YWYieHZ6HvIOCJyS7+aFdSWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

(Partially drafted with the help of Claude)

On Tue, Mar 03, 2026 at 04:02:14PM -0800, Ben Greear wrote:
> Could the logic that detects blocked work-queues instead be instrumented
> to print out more useful information so that just reproducing the problem
> and providing dmesg output will be sufficient?  Or does dmesg already provide
> enough that would give you a clue as to what is going on?

It may not be exactly the same issue, but Breno just posted a patch that
might help. The current watchdog only prints backtraces for workers that
are actively running on CPU, so sleeping culprits are invisible. His
patch removes that filter so all in-flight workers get printed:

  http://lkml.kernel.org/r/aag4tTyeiZyw0jID@gmail.com

Might be worth trying.

> If I were to attempt to use AI on the coredump, would echoing 'c' to
> /proc/sysrq-trigger with kdump enabled (when deadlock is happening) be
> the appropriate action to grab the core file?

Yes, that's right, but you need to set up kdump first. The quickest way
depends on your distro:

 - Fedora/RHEL: dnf install kexec-tools, then kdumpctl reset-crashkernel,
   systemctl enable --now kdump
 - Ubuntu/Debian: apt install kdump-tools (say Yes to enable), reboot
 - Arch: Install kexec-tools, add crashkernel=512M to your kernel
   cmdline, create a kdump.service that runs
   kexec -p /boot/vmlinuz-linux --initrd=/boot/initramfs-linux.img \
     --append="root=<your-root> irqpoll nr_cpus=1 reset_devices"

After reboot, verify with: cat /sys/kernel/kexec_crash_size (should be
non-zero). Then when the deadlock happens:

  echo c > /proc/sysrq-trigger

The system will panic and boot into the kdump kernel. Note that the
kdump kernel runs with very limited memory, so you can't do much there
directly. Use makedumpfile to save a compressed dump to disk:

  makedumpfile -l -d 31 /proc/vmcore /var/crash/vmcore

Most distros' kdump setups do this automatically. Once the dump is saved,
the system reboots back to normal and you can analyze it at your leisure
with drgn:

  drgn -c /var/crash/vmcore

Thanks.

--
tejun

