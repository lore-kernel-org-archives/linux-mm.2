Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE9FE606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YGNhEOdl
Received: by kanga.kvack.org (Postfix)
	id E43606B082B; Tue, 24 Nov 2026 13:35:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD006B082D; Tue, 24 Nov 2026 13:35:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBCEA6B082E; Tue, 24 Nov 2026 13:35:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D7896B082B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:35:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DDA1160566
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:35:49 +0000 (UTC)
X-FDA: 85470866418.18.7AD72B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E8738000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:35:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YGNhEOdl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795545347;
	b=kWJszdd++IW4Rf1QVlcq738oxH/bgo7aZB/TTq7/S9ADfng6IhoU710gdjE6r+iyiT0R1k
	BGPUJl8TdFK0r3Fy13WTPrhFqTxV0+CPXecVEWJsYPrCaUOEmpw+ehoEIPkNfXzKRMUJ64
	c4gjMCrDLorvZWczuNBtszMzKRG9sqY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795545347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NH+LCPbT58VTTOKIoQohmGo8BCrcjnPK+zFjIzwgB7Y=;
	b=gBSaBubJ1BiQ9i7gUsPJaJIHujq0y7IZXb5RmhL96d1c9ixd3xIUxSziu4vjvnV0aTTKYp
	2Ln/ASTkVxvgckQLF2tW9l8VVAYddfM80YZ/iu1/m8VQH0rO7MhPJSElGe68yjq/upjPFM
	euleMRF+0FtxrvOAq8F1LCYPUfGHhok=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YGNhEOdl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 09A5F623C9;
	Tue, 24 Nov 2026 18:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CA1681F000D8;
	Tue, 24 Nov 2026 18:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795545346;
	bh=NH+LCPbT58VTTOKIoQohmGo8BCrcjnPK+zFjIzwgB7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YGNhEOdlnPN871G/X9PPWV2KDkNfg6lDAYL74NQ4uMZDrqBjOHxooLjxN6J9DJyuN
	 epQrEamKS5eGTLTDPRfDiX5spXFiq6j1WSiqUG/PtKfJ1tZSmLYqwKylZQhk9WPX7B
	 bEM8oPgYlXgUet8cYtuVzgh8rRxJEj8ZgkcD4hk3pA4UHghl4N8J0BPQIsCsPCZAFd
	 +kJTyztWJCLJ50m3BrED2g/opMxeaUu7STWXnyQ8A3/RFw4OBjGhmM9kNWyBlQHyvc
	 cKvYRL1apD8f0X5RwzYPerXPlVzxh1JZGzc30tc5hQHHP60AIzOQqgM3p4OYptBszq
	 3eYlMbouXqYYQ==
Date: Tue, 24 Nov 2026 20:35:42 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awXY_gKSqi-L5V30@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awTmJIErjasO4lqq@kernel.org>
 <awToL2PFNKVgIfqs@kernel.org>
 <awUGkYoyDXp4P5LJ@kernel.org>
 <awULfmZR-pESj2EC@kernel.org>
 <awVInf04kGC0uZZo@kernel.org>
 <awVRz8XC54nfevtW@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awVRz8XC54nfevtW@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: piuw6rd6y8ftmpphcjxezdowqdostb6w
X-Rspamd-Queue-Id: 8E8738000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795545347-664352
X-HE-Meta: U2FsdGVkX1/PLYrj/hTfOhGYm5eAjJiv78ET9iFXMlkKpz9EcqY8TbGb4lDfhSo2RQJoLc9S4GKdhlzlIejaWc/9kHF8dImVOW4BI1WeMwj9+SUCbC8IuB1K+5u21byiMt+sNNfX4i3owDJRzdNzDaN0Mr/AvzwdKKeg0f8qdg47z/aZVJ/QOElKj1ylWrRamhbrlSBTFGqXOK86l9mRgcmDI6+/Lgjhc2OetZ5I3zYi8gzW+TeAuC2MXSQuCW8xEJFHC80/7gGcoqhBBdhjgWqOnQ2eJsaaYjAuCJk08A9j8DDJdTWjBRUYHIbrqpnB5XU0PVTW7eAOU8J88mozVKptjJ67GHzXgLdHZcRaG96JerpmZ4Vf2GCF7zgQ/r3/hO5YdAsaKkH0uAp2ddeCnxQIHijbSLvm8i4HgZuvsaIA0S7iVmOd/dbXIPmG/roXH5NnADdKri+ghxrUZ6LbmTFZPnth+IgJSQ7VhRessISZ2kmk2esuiroW3P5n7rYEYRD8LhkibNj5TDLX1GAjbFbXan/JuxDsqKEY1mid4+U1rydsFCiZ8hMZMExKzQUAE+/3YiezqLwfrdGSLBsR+eyybOgehGWGPY+uhRBa4gNRjiCOH9YWiducCERBK8k4wLVKBfdi4bUOKJCW9n7ONiOwLKkiiISAytgu8WxXeNhu3ppp53xK9bdfav5+Mck30NlaiC0SMqXORwupQBrjCp71OeqfNliw+E17WlXTNig4qkuAjTHB0/h3sVK4JsG6f31ZdKU1ttxhYitFhvKN3TA4tdSxUJg6NZBLOYCz8eKNkGKELN4BEril+4sEeHoVEU4JYy86WBIBw3/elOyi4Z7KuIT/3PtmOA8oaSSYPXvhKYl959DLXmhGZeaCR3ZQy4bEDU9Nf/DlS8Dmgssj3QpOTETDL6syJ0HKuXommiRqAJ+v31uY6VWnKnLHciJz4MrkBu7a+1thTmW2mWb
 cUKdglEv
 Fm0LZ61kjuE2naNc/TeLNq/aUoEyQ+2/egZVRGFAt+Miqjih1PqtSPp2BYvfaHL4p6LhMqpXujZexPcrypiMfeQcbVVYcZ0h4XpX/MOAkvNC+bhUnuuFjHE2cUb+I2yrRjnZ3G1C2DttX+OaoFm9j48pebpcPlOtPBFsoNgHGFXK8FAIZ0kpiERst1x5VhUQvchkvgTErtHnf2FzQMZ6P4ZD6Mtxy9bkEhXTJi6+uRj4dkwJvsLcZGQvYN+UFDiYAopQRcLwPkaVUsvdrqxUaRcsLDC+mcgMojDTI+c71FExl8Y3j4UJ2KTyOLdbmTxsXEtGSbeX0eFCDTZXi0IlfmIxVJwkh8kZqHXCppDOL3Y/Fn5xK/RFOObTae1eOUH0quZdLLq+9lEFf/wT4sHxTFNoxR38NP5miTJfKyq5lKJIoJNXrFhw5yoXBT0nNUU9AtMQ6j2R591wKDSm2Jw+XYKMDcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 10:58:55AM +0200, Jarkko Sakkinen wrote:
> > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=vault
> 
> The key function to look up from here is spawn_userland_container():
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/br2-external/patches/systemd/0010-nspawn-Start-containers-in-an-experimental-userland.patch?h=main
> 
> It demonstrates an initialization flow that ends up cleanly with
> clone(). userland_share_host_ns() demonstrates the ioctl I added
> previous week i.e., USERLAND_SHARE_NSFD, which is used to punch those
> host namespaces that the guest actually needs. This is the allow-list
> part, which is usually the favorable principle over deny-list.

This proves that bootstrap ends with clone3(CLONE_INTO_USERLAND), which
the most important property to prove at first.

The second part is "hotpluggability" property (hmm... is that even a
word). I have early local patches for this but they ares still unpushed.
I need to test this again with real hardware as I did in ad-hoc manner
previously. I don't think QEMU is acceptable for this alone.

However, it is not really rocket science with these tools, and it would
require effort to get these completely wrong, especially if they are
stressed even slightly with bare-metal hardware:

	nspawn: Hotplug device nodes into userland containers via udev

	Defer absent /dev bind sources when starting a container in a userland,
	keep the userland mount namespace fd open in the supervisor, and attach
	an sd_device_monitor to the supervisor event loop. When matching device
	nodes or optional API devices appear, update the container scope's
	DeviceAllow= property, populate the dev node and /dev/{char,block}
	symlink via its root fd, and attach the device mount with
	MOVE_MOUNT_T_MNTNS.

	machined: Allow bind mounts on user-namespaced containers

	When experimental support is enabled, bind_mount_in_namespace() attaches
	mounts via MOVE_MOUNT_T_MNTNS without entering the target's namespaces
	and refuses to fall back to namespace_fork() for foreign user
	namespaces.

	mount-util: Attach live namespace mounts with MOVE_MOUNT_T_MNTNS

	When experimental support is enabled, create missing target mountpoints
	through the target's root fd and attach bind mounts and dissected images
	directly into the target mount namespace fd instead of forking a
	setns() helper process. Fall back to namespace_fork() when the kernel
	does not support MOVE_MOUNT_T_MNTNS.

They are variation of the same pattern, and pretty obvious even from the
descriptions. When they are known to work, I'll push them.

Br, Jarkko



