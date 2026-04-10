Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE82F459F3
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964646B00A2; Fri, 10 Apr 2026 11:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93BA56B00A5; Fri, 10 Apr 2026 11:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A8E6B00A6; Fri, 10 Apr 2026 11:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 659956B00A2
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:19:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06CBC13A1F7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:19:07 +0000 (UTC)
X-FDA: 84643004334.28.A6E0836
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id 03F6DC000F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:19:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=VM9pR3FU;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf10.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834345; a=rsa-sha256;
	cv=none;
	b=WThw/otuwiDo91oli1tyQQ5ohD4KOt4Q1W/1N/0uLoq4E4lXP6ZX3PRd3O2AR38kY0OYnP
	zPkhfeKu9Pp92Mxm7SeXlQl2wdWdRh1KKjRcdcYrZmDEKlgqTaky63vwX+8mW+J5MiUKHw
	IZX5G7EgB0WXqkJ3ra4o/ICkOOtl4gI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=VM9pR3FU;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf10.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTlXD+fEi5OyNbu4TxRTwpDmEzFd2ThBwniicSqJG9M=;
	b=trihY2IOx6JcMyr3dBIAsi0JOVJLHyuobDTjKEwRfYbLJtAlyZc+4A3DQIhy6IaN77RGJU
	aCnZqfhQnkJftckyatQO5tTmitfgzOrjbhDlnquhgvJw9IdCvl9NY5wpp9EFSEe3Hez3aU
	0mSoy9Deo3O7zZ7SeVFupmCypVtWePM=
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFIonm015842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834338; bh=eTlXD+fEi5OyNbu4TxRTwpDmEzFd2ThBwniicSqJG9M=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=VM9pR3FUqiyu4dGQLYjxtn5fwtIzfU7ySZMp0abbH18xV6/gDABRi9uB743lXz8hh
	 DLg+D58JGiw6cmfTe96qrNZsfI1LrX8CH4Z4SZsryjUI4LnJNSYnME68kmTAWN0bac
	 +APmObxjmRctPfSGmHJbriSXfrkN55pWYIbiVRfu2y0ECqpOPHSJun6K+BHM+LkVI2
	 DM7T+QYmlRWbU/sqPlO03FdXluf2F9iRmmuiDmCsbPLwL4U9izV2zs90P/AyWnNi7/
	 WJE2W3FtW9KojAgen2wKI5w3YJJGh4CS8IuF5T47bMgUta6WPQzUW9F7QaunmIRgXz
	 enYXQQPwNnobw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0D7462E00E1; Fri, 10 Apr 2026 11:18:48 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
        bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
        dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
        gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
        sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
        Philipp Hahn <phahn-oss@avm.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 04/61] ext4: Prefer IS_ERR_OR_NULL over manual NULL check
Date: Fri, 10 Apr 2026 11:18:40 -0400
Message-ID: <177583430870.2758959.6171961359325912353.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310-b4-is_err_or_null-v1-4-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-4-bd63b656022d@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03F6DC000F
X-Stat-Signature: ot7pbsgko8psp7mdc99xnzjxgeyuqcnw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775834344-557630
X-HE-Meta: U2FsdGVkX19pOryah7jnuVVt77YVuEdi+s0SECK895h2Zyh+NieUGZcmyOtGVIOW0gKKaO144BcASTVsZ4LxPcZxkosovvxkzo5pHeSQanQmU1W/SxDq6nvbFg1bunQpzeAJicNxDAhkWZ8UF/xdB5/Qsou7ZDTgP9UffOM39M7qU16wtrJASAZNHhGhwHpAL1op73clgteLQbv7+beCeUd8Tb9hteT4GuHZ4G1zTQsT9hV3x/qx2dVfvh4vQ8iFAk8O0JW0yVgh4hHa8C1U+/WjzEe8IS/7U4gfHHWRYOISZf8XbwLnrPwKKqXdCC+WHiuiCSQFi+z7JdkJnVj2xKuquGil1jjc/cAf+vl/FG9GLrTpATdFhCXgvS6njLJzNEftZ9tIeACtcCcSdcXn2XPYRBR9+ev+B+PaHjLg/EAHYMF8/RH17BkrxIrDUsqEJPuqy0zILIQN2aUwJpRk4AfVdPLkjNWu1ff6EgxuCuvflqVp4zwkaD/XyES9elX1WMp2TbkUPYLvy0IOEBzScXbUVhNlhEmZHhFgDQdwkkg0J2d7wysqVAZ0wY5USE0uWqv3zm5Hc1hEf2aUgBEJN+pT3sX41qNCN+efoup7N01v0RHbVw1m/Z/t0v5sttmsOyFpM2tD9ckdnIViRxKTMWH5XuLN+w+ZkS8AsxQMBUrehs6ejz+5OEjURTDaTfulyaV3s/mOCf7jqtkF5mWqpB82917sQ+IvFCzpEImf/GkdfQQPCjhb9HmH3GtvP5tekyNzaoH5QV5P9wMcfPHGcWiQgMgcA46OxoBec91FvjW5vFeX99SzDfrW6gp7eQvx/z1ymH0lYT/PBZC43QXjXS2BCfxgaCBFatzFmBIs9dsW798s9USQMjjxJuqI00d7IbVhinKwbCWihqu0M4hpBwEC5EKXyZ/7Eajs3zjcJdpx+pV8mNQ4WqDWqgK/eWzkrPW3ALhe2XRGyjUU74H
 WoHDYzE4
 xX2e+ANzlBxVliKq8v2l71pTrhszUX9g8rofmPNV/oyZScD/LKjvAzh5N9/c8heKe4ZprgVMIFRVILsK0vlKpTFaiTDXE2ICMYYJzwBf7WeDniyq6+cFlLjj6n4NgwVvuvFexZI0H1nnH5pB2S7W1tWqr4cA8w4wu/Q73GqKhZBctQdcxvbykV9I0KTCrv8iw+I6yoUs0avQa4PPa0I0B3BrFDNQ7Q4JFE2fQ5ADJVO84B3kMozhsj7Ob8Me1mIt4H6BSy0UQSUK96to=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, 10 Mar 2026 12:48:30 +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Change generated with coccinelle.

Applied, thanks!

[04/61] ext4: Prefer IS_ERR_OR_NULL over manual NULL check
        commit: 1d749e110277ce4103f27bd60d6181e52c0cc1e3

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>

