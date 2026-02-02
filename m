Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D6EE7DF0F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F73E6B00CC; Mon,  2 Feb 2026 12:50:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1476B00CD; Mon,  2 Feb 2026 12:50:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6436B00CE; Mon,  2 Feb 2026 12:50:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 66FFB6B00CC
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:50:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0836513A074
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:50:44 +0000 (UTC)
X-FDA: 84400256808.19.5C42B98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E0F651C000E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:50:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KdR2g8AT;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770054642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1c5poQRup3YXuAN3Jt7CXVp0hwqqt2q83Twq2hwFWP0=;
	b=sY4GRTfHZECAAbTz1s6MoIHbj2RfPxlvXpdl/wFWxy/uDaDNv3tGZPS9CIImGamT7TnR8y
	sKem5vNRXeDJFxeW4F0stxvSopghEbmDg75nX7Rs6eJBtTDDCpQPknggzPZIKbW6b8yU+u
	qDsHpCB9Io5BYI0a8zfl3QQhxtEfWcU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KdR2g8AT;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770054642; a=rsa-sha256;
	cv=none;
	b=RpEYtUR4pJW8jl5QsKMP4hYWxk5kLbC4spEvr5j50zydBsHhnufUaugu5HY5gku4Z9vP/6
	IHJY513Q/SdpqpS5lygLIqJUFydDoakKCOFBO8+s9YbG4XY+bUD/VLynag+3CXLTjE7C5y
	A9FV/lKVDp57QmMClYOPozQOoCBWQSk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7D424447F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE7AC2BC87;
	Mon,  2 Feb 2026 17:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770054640;
	bh=1sO4SKx86mkHcoOMUXgtGHCRc6KnJdnIPMym5JQh9XY=;
	h=Date:From:To:Cc:Subject:From;
	b=KdR2g8ATI5/bXDxYtVz6qOO4VHiY4CeNr6fr2pl+aCb5nQl/sM0caP2ZI0ImYOMLC
	 EX0u4UwSCtp0TrZ0htwoqggetW/4NeCszvfda50mvDcjMFaTDtD+EeAYqv/FdLrtTH
	 jBmJXRiFq8ncRaclMUNns22R64apj3bcxsVE0aqeBgLrHPsw2ng7KZri+XnnsgkH3M
	 HTkb3sSFv/iij0e+UMwDlwg9Isx6WONwhKgiSjIWzhB9wNJHyhB9omPUI044WqzfcH
	 bobYUIgtdU91jTZZw/o5Y2ytU0DWCCZirTP03s2U0K1UFHT5tcpRxzehJLwEng1nxe
	 WeCG5R/BjP9QA==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.phl.internal (Postfix) with ESMTP id 51B67F40069;
	Mon,  2 Feb 2026 12:50:39 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 02 Feb 2026 12:50:39 -0500
X-ME-Sender: <xms:7-OAaYZxzeFyZP9fOQN03vJkJHuozO4bimEtg7nx2iL_Yn6fxablaA>
    <xme:7-OAacJVKDHr3xRyTm8tULuhm-zvdnyyPnIpqC-Nku7Mk39xl29zEXskJo-mfjDN8
    Hr-bgX_95XSGMbCUMPrRD7wxm02rOzRrNvwewzgZDcKBk4WRhWuHQ>
X-ME-Received: <xmr:7-OAaRrvr8Cd_loyMoHZcJrzG-epcWax6CNYhy2FKGvKpIdn-5kNLt-Nc11Q0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeekvdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkgggtugesmhdtreertddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    epvdevudegkedvgfffjeejteejueektedttdekkefhtdeuveeliedvudevgefgvddunecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepudeipdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsghrrg
    hunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdrtgii
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepsggroh
    hlihhnrdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopehl
    ihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvg
    hvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgv
    rhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:7-OAaVDBzHX41GcX-OlD7tAtq4go3k2hxzu05NMsvnw6drCXK0hCPw>
    <xmx:7-OAaXfuUk8M-Hq0Gwa0T6aFjlkkS4rl-r4FrgFamN3_lQKMLY_KEQ>
    <xmx:7-OAaVIpOVSxuwbLH3YEJRATTyovgLc3whHimPHemdcaUchgAWhgSA>
    <xmx:7-OAaXtNtIDXl4x3ykYRUVQVDsiEHuQKg5m7Xlf1755O8flCKYEI4g>
    <xmx:7-OAafbcqPb7IztY10j8byc90_YJ7U8S46VALWIeLba52O5z_qDvHxEF>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 12:50:37 -0500 (EST)
Date: Mon, 2 Feb 2026 17:50:30 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Orphan filesystems after mount namespace destruction and tmpfs "leak"
Message-ID: <aYDjHJstnz2V-ZZg@thinkstation>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="odh3srnjw53gxerh"
Content-Disposition: inline
X-Stat-Signature: kfxzqdx8xkad8gc7iz1jewh3ppj47gsr
X-Rspamd-Queue-Id: E0F651C000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770054641-416528
X-HE-Meta: U2FsdGVkX1/HezMGst1kaaWA7lFuLhSgIg5PWtlFoI+Y/iZtZqmzrEe1oDXEMECASPUWxsKxExI4XomnR+/VzUSuQTElGkPDbbwOY5fEl2jDsO+6vdpSUVJ/foFEfTh45Q2nzql1WAzLJw44um2iRSXECFI10Up6O+tcLMclhpcyxDJxhO4yQPjFb5djufuibcaGQRWax4Ky76+fmPxCourW3ZeBwWgQzPMkx+frnCCqOKMjkYVVYTUL7pCVtf/A8uSjHRnB7Y0pWaeXwLeCT/WDMpNM8QxZwA/2YhBtKuXgJ2CiKRDW+ogfF25DWIFWvkG8CcWRspLTlAjZroMbRWDBlgo5dh2oGOshK4Aa3MBhf86Bbr+o207yTpoT4G+qJ/CV6lB0FNTeCT7Dt+J3xS68WjAUXlny4Sx9q2IyC/N5OnmHouZDEshM8VuffdmgrfBm0CDq0uw+SerocP4KKLL31zM1Eqw8imRxr/YidSYfCiwezA6z/mIaow6uHqkn42S+QOu5QJu6NB5SHvtu99pmx5sdbAfkfJlmmyBwW2ngRifR8eF/QP3MhTqmI5lch06uJDjxUnFtPb9Fxgs36TdLWMirTnhqrFv3CGV6A5ady44kmP0y/qmC7RPNojPPoxIVJRTAzFihL8HuqsbCpYiNKL29CZ3EAlaMnSfgTQAemIde4H3Oj+z/LvFKx5QHAw5uhzzVB1dPGsvT0H2Dsrod0f343/Z1YD5yeVGkSfHGlPD8VLCA4n3voMoFRJ5M6f3/FJJfQo8jdWULQyMQ2SDRmR6DGV6Vi38RFA3CQpivsh0cuivI35TTfgFSK8hRShr8FOEpZW9cyL68+Oe0dCdjdhHgrORn3sTZiOqDyjlu7YEBK2i9Sk9X+UoqKxP9VxjWjAcdNMs+VmeXbWAEY0WXf4jGq3gEiUke7SGtmkXHdBj5shI8fnvcm4GH6kCKyQ7AM9XOOycbZzk1T0F
 DimtkQA+
 30vACYc8ndYQT9wevzrjkEN9RqLr7pmAiy9Azb48xzsG5uxY8ou7Nk7oTUGwi2ktn5RmomoDFQ817wLi3RtI7dV5foHdn2dFG9o9ojqo3xsu774kI3pgr6X8JCYZfPdoWzQQUmGPnaCYhGcSK6lWb/QNxx048HdjWe/JdfzmHAY/OxmKkT6lzJPcwql5MQraH011sUDVP8uSy81NFzoJD4AaC40r/sBdv4Rr/igFWY/+o1o3GyCHQBULgrxT68YdIwshmxJwB8lV9ZRNx10af5jy4eFIZByTl+r1E6nJjIVsmQba7vPZlvDPv53fyVYSalhSMrdI6U/DnJ3cldxG30yX2nL7REwBjxSXB7zrfF7ZiATBk58P5baoFIbMGNRXQb+EYWsJjMNfJzZZwExOFkwxvbp+RPN0XxS6bwqyLu/vACRIaRlxbEI/rzhtyh9ePnNOqLfXJ9hOjNgMe7i8a7sVmzdbO/mu5VbMV6UqIrBN2nJC7pwj+XwcF2AP92k6DxJNhmALVlueLDZ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--odh3srnjw53gxerh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

In the Meta fleet, we saw a problem where destroying a container didn't
lead to freeing the shmem memory attributed to a tmpfs mounted inside
that container. It triggered an OOM when a new container attempted to
start.

Investigation has shown that this happened because a process outside of
the container kept a file from the tmpfs mapped. The mapped file is
small (4k), but it holds all the contents of the tmpfs (~47GiB) from
being freed.

When a tmpfs filesystem is mounted inside a mount namespace (e.g., a
container), and a process outside that namespace holds an open file
descriptor to a file on that tmpfs, the tmpfs superblock remains in
kernel memory indefinitely after:

1. All processes inside the mount namespace have exited.
2. The mount namespace has been destroyed.
3. The tmpfs is no longer visible in any mount namespace.

The superblock persists with mnt_ns = NULL in its mount structures,
keeping all tmpfs contents pinned in memory until the external file
descriptor is closed.

The problem is not specific to tmpfs, but for filesystems with backing
storage, the memory impact is not as severe since the page cache is
reclaimable.

The obvious solution to the problem is "Don't do that": the file should
be unmapped/closed upon container destruction.

But I wonder if the kernel can/should do better here? Currently, this
scenario is hard to diagnose. It looks like a leak of shmem pages.

Also, I wonder if the current behavior can lead to data loss on a
filesystem with backing storage:
 - The mount namespace where my USB stick was mounted is gone.
 - The USB stick is no longer mounted anywhere.
 - I can pull the USB stick out.
 - Oops, someone was writing there: corruption/data loss.

I am not sure what a possible solution would be here. I can only think
of blocking exit(2) for the last process in the namespace until all
filesystems are cleanly unmounted, but that is not very informative
either.

I have attached a Claude-generated reproducer and a drgn script that
lists orphan tmpfs filesystems.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

--odh3srnjw53gxerh
Content-Type: application/x-sh
Content-Disposition: attachment; filename="tmpfs_leak_reproducer.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A# Reproducer for tmpfs leak via external file descriptor=0A#=
=0A# Scenario:=0A# 1. Create a "container" (new mount namespace) with a tmp=
fs=0A# 2. Create a file on the tmpfs=0A# 3. Process outside the container o=
pens the file via /proc/<pid>/root/...=0A# 4. Container (mount namespace) i=
s destroyed=0A# 5. tmpfs remains alive because external process holds a ref=
erence=0A=0Aset -e=0A=0AWORKDIR=3D"/tmp/tmpfs_leak_test_$$"=0Amkdir -p "$WO=
RKDIR"=0A=0Acleanup() {=0A    echo "[cleanup] Cleaning up..."=0A    # Close=
 FD 3 if still open=0A    exec 3<&- 2>/dev/null || true=0A    jobs -p | xar=
gs -r kill 2>/dev/null || true=0A    rm -rf "$WORKDIR" 2>/dev/null || true=
=0A}=0Atrap cleanup EXIT=0A=0Aecho "=3D=3D=3D tmpfs Leak Reproducer (Shell =
Version) =3D=3D=3D"=0Aecho ""=0Aecho "This demonstrates how an external pro=
cess holding a file descriptor"=0Aecho "to a file inside a container's tmpf=
s can prevent container cleanup."=0Aecho ""=0A=0A# Step 1: Create a "contai=
ner" process in a new mount namespace=0Aecho "[1] Creating container with n=
ew mount namespace and tmpfs..."=0A=0A# Create a pipe for synchronization=
=0Amkfifo "$WORKDIR/container_ready"=0Amkfifo "$WORKDIR/external_ready"=0A=
=0Aunshare --mount --fork bash -c '=0A    WORKDIR=3D"'"$WORKDIR"'"=0A    ec=
ho "[container] PID: $$"=0A    # Make mount namespace private=0A    mount -=
-make-rprivate /=0A    # Create and mount tmpfs=0A    mkdir -p /tmp/contain=
er_tmpfs=0A    mount -t tmpfs -o size=3D10M tmpfs_device /tmp/container_tmp=
fs=0A    # Create a file on the tmpfs=0A    echo "Secret container data - P=
ID $$" > /tmp/container_tmpfs/secret_file.txt=0A    echo "[container] tmpfs=
 mounted at /tmp/container_tmpfs"=0A    echo "[container] Created /tmp/cont=
ainer_tmpfs/secret_file.txt"=0A    # Signal ready (write to pipe)=0A    ech=
o "ready" > "$WORKDIR/container_ready"=0A    echo "[container] Waiting for =
external process to grab FD..."=0A    # Wait for external process (read fro=
m pipe blocks until written)=0A    read _ < "$WORKDIR/external_ready"=0A   =
 echo "[container] External process has FD. Exiting in 2 seconds..."=0A    =
sleep 2=0A    echo "[container] Exiting now - mount namespace will be destr=
oyed"=0A' &=0A=0ACONTAINER_PID=3D$!=0Aecho "[main] Container shell PID: $CO=
NTAINER_PID"=0A=0A# Wait for container to be ready=0Aecho "[2] Waiting for =
container to set up tmpfs..."=0Aread _ < "$WORKDIR/container_ready"=0Aecho =
"[+] Container is ready"=0A=0A# Find the actual unshare child process=0Asle=
ep 0.5=0ACHILD_PID=3D$(pgrep -P $CONTAINER_PID 2>/dev/null | head -1)=0Aif =
[ -z "$CHILD_PID" ]; then=0A    CHILD_PID=3D$CONTAINER_PID=0Afi=0Aecho "[+]=
 Container process PID: $CHILD_PID"=0A=0A# Step 2: External process opens f=
ile via /proc/<pid>/root=0Aecho ""=0Aecho "[3] External process opening fil=
e from container's tmpfs..."=0A=0APROC_PATH=3D"/proc/$CHILD_PID/root/tmp/co=
ntainer_tmpfs/secret_file.txt"=0A=0Aif [ ! -f "$PROC_PATH" ]; then=0A    ec=
ho "[!] Cannot find file at $PROC_PATH"=0A    echo "[!] Trying with contain=
er shell PID..."=0A    PROC_PATH=3D"/proc/$CONTAINER_PID/root/tmp/container=
_tmpfs/secret_file.txt"=0Afi=0A=0A# Open the file and keep it open - save c=
ontent for later=0Aexec 3< "$PROC_PATH"=0AORIGINAL_CONTENT=3D$(cat <&3)=0Ae=
cho "[external] Opened FD 3 to: $PROC_PATH"=0Aecho "[external] File content=
s: $ORIGINAL_CONTENT"=0A=0A# Signal container we have the FD=0Aecho "ready"=
 > "$WORKDIR/external_ready"=0Aecho "[external] Signaled container"=0A=0A# =
Wait for container to exit=0Aecho "[external] Waiting for container to exit=
=2E.."=0Await $CONTAINER_PID 2>/dev/null || true=0A=0Aecho ""=0Aecho "=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D"=0Aecho "[exte=
rnal] CONTAINER HAS EXITED!"=0Aecho "[external] Mount namespace should be d=
estroyed"=0Aecho "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D"=0Aecho ""=0A=0A# Show we still have access - use /proc/self/fd/3 to=
 read=0Aecho "[external] But we still have FD 3 open!"=0Aecho "[external] R=
eading via /proc/self/fd/3:"=0Acat /proc/self/fd/3 2>/dev/null || echo "(re=
ad failed - but FD still holds reference)"=0A=0Aecho ""=0Aecho "[external] =
FD 3 details:"=0Als -la /proc/self/fd/3 2>/dev/null || echo "(fd info not a=
vailable)"=0Areadlink /proc/self/fd/3 2>/dev/null || echo "(target path - n=
ote it's a deleted/orphaned file)"=0A=0Aecho ""=0Aecho "[external] The tmpf=
s superblock remains in kernel memory!"=0Aecho "[external] Even though the =
mount namespace is gone, the superblock persists"=0Aecho "[external] becaus=
e we hold a file reference."=0Aecho ""=0Aecho "[external] Holding FD for 10=
 seconds to allow inspection..."=0Aecho ""=0Aecho "You can check with: sudo=
 drgn monitor_tmpfs.py"=0Aecho ""=0A=0Asleep 10=0A=0Aecho "[external] Closi=
ng FD 3..."=0Aexec 3<&-=0A=0Aecho "[external] Done. tmpfs superblock should=
 now be freed."=0Aecho ""=0Aecho "=3D=3D=3D Reproducer Complete =3D=3D=3D"=
=0A
--odh3srnjw53gxerh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="monitor_tmpfs.py"

#!/usr/bin/env drgn
"""
Monitor tmpfs superblocks to detect orphaned/leaked tmpfs filesystems.

Run with: sudo drgn -s /path/to/vmlinux monitor_tmpfs.py

This script lists all tmpfs superblocks and shows which ones have
NULL mount namespaces (orphaned) or are otherwise in unusual states.
"""

from drgn import container_of
from drgn.helpers.linux.list import hlist_for_each_entry, list_for_each_entry

def get_mount_info(sb):
    """Get mount information for a superblock"""
    mounts = []
    try:
        for mnt in list_for_each_entry('struct mount', sb.s_mounts.address_of_(), 'mnt_instance'):
            try:
                mnt_ns = mnt.mnt_ns
                mnt_ns_addr = mnt_ns.value_() if mnt_ns else 0

                # Get device name
                devname = mnt.mnt_devname.string_().decode('utf-8', errors='replace') if mnt.mnt_devname else "?"

                # Get mount point
                mnt_mountpoint = mnt.mnt_mountpoint
                if mnt_mountpoint:
                    name = mnt_mountpoint.d_name.name.string_().decode('utf-8', errors='replace')
                else:
                    name = "?"

                mounts.append({
                    'mnt_ns': mnt_ns_addr,
                    'devname': devname,
                    'mountpoint': name,
                    'mnt_addr': mnt.value_()
                })
            except:
                continue
    except:
        pass
    return mounts


def main():
    # Get the tmpfs/shmem filesystem type
    shmem_fs_type = prog['shmem_fs_type']

    print("=" * 80)
    print("tmpfs Superblock Monitor")
    print("=" * 80)
    print()

    # Collect all tmpfs superblocks
    tmpfs_sbs = []
    for sb in hlist_for_each_entry('struct super_block', shmem_fs_type.fs_supers, 's_instances'):
        tmpfs_sbs.append(sb)

    print(f"Found {len(tmpfs_sbs)} tmpfs superblocks\n")

    orphaned = []
    normal = []

    for sb in tmpfs_sbs:
        sb_addr = sb.value_()
        s_dev = sb.s_dev.value_()
        s_active = sb.s_active.counter.value_()

        mounts = get_mount_info(sb)

        # Check if any mount has NULL namespace
        has_orphaned = any(m['mnt_ns'] == 0 for m in mounts)
        has_normal = any(m['mnt_ns'] != 0 for m in mounts)

        info = {
            'sb': sb,
            'sb_addr': sb_addr,
            's_dev': s_dev,
            's_active': s_active,
            'mounts': mounts,
            'has_orphaned': has_orphaned
        }

        if has_orphaned and not has_normal:
            orphaned.append(info)
        else:
            normal.append(info)

    # Print orphaned superblocks first (these are the leaked ones)
    if orphaned:
        print("!!! ORPHANED tmpfs SUPERBLOCKS (potential leaks) !!!")
        print("-" * 80)
        for info in orphaned:
            sb = info['sb']
            print(f"Superblock: 0x{info['sb_addr']:016x}")
            print(f"  s_dev: {info['s_dev']}")
            print(f"  s_active: {info['s_active']}")

            # Try to list some files
            try:
                root = sb.s_root
                if root:
                    print("  Root dentry contents:")
                    count = 0
                    for child in hlist_for_each_entry('struct dentry', root.d_children, 'd_sib'):
                        name = child.d_name.name.string_().decode('utf-8', errors='replace')
                        inode = child.d_inode
                        if inode:
                            size = inode.i_size.value_()
                            print(f"    - {name} ({size} bytes)")
                            count += 1
                            if count >= 10:
                                print("    ... (more files)")
                                break
            except Exception as e:
                print(f"  Error listing files: {e}")

            for m in info['mounts']:
                print(f"  Mount: {m['devname']} -> {m['mountpoint']}")
                print(f"         mnt_ns: 0x{m['mnt_ns']:016x} (NULL = orphaned)")
            print()
        print()

    # Print summary of normal superblocks
    print("Normal tmpfs superblocks:")
    print("-" * 80)
    for info in normal:
        devnames = set(m['devname'] for m in info['mounts'])
        namespaces = set(m['mnt_ns'] for m in info['mounts'])
        print(f"0x{info['sb_addr']:016x} s_dev={info['s_dev']:<4} "
              f"active={info['s_active']:<3} "
              f"mounts={len(info['mounts']):<3} "
              f"devnames={devnames}")

    print()
    print("=" * 80)
    print(f"Summary: {len(orphaned)} orphaned, {len(normal)} normal")
    if orphaned:
        print("WARNING: Orphaned tmpfs superblocks detected - these may be leaking memory!")
    print("=" * 80)


if __name__ == "__main__":
    main()

--odh3srnjw53gxerh--

