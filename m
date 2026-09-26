Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3316C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 17:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A946B0088; Sat, 26 Sep 2026 13:51:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B906B008A; Sat, 26 Sep 2026 13:51:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CA86B008C; Sat, 26 Sep 2026 13:51:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33B336B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 13:51:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AB7AA07CC
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 17:51:26 +0000 (UTC)
X-FDA: 85256655372.26.1D7F595
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0ACA940004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 17:51:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DD1lP/Qm";
	spf=pass (imf04.hostedemail.com: domain of nsc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nsc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790445085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+l/+xlFQ9oYX3AqDOoZ5UJ8jLQiMbyYFqszTxwXHlbY=;
	b=roxilaZeW6qnme0cZD9oaPu2fkUkEhO5kNdiuJyuYgncaXKdNb1ID5auV20SsaDNadYXV0
	5F8QyoofOsuhl9kr5N0RJMGftRQKqySnrIwdIfc5mqt3VzN/CGCjBQDC2suZRwJxcrTKPL
	uXz/mCghMgpQThYy1rsRvoAmkjI9J8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790445085;
	b=Sp4PZ/LoVX9kQCYZo0F7rJN7hVAg3hkmXISY6xHT6Ib4ADevnCiQkk+JuGOxLE/hS1WIzM
	JTjSZWgcU/KW5RuUBiBSHvlFTaMSQD/VtF9ri/raboRPJmv7xDbHm8/NEzV01kPlPcEQUt
	MXA5BJeuLZTyXdbx7Eu99ZptNF28Mjg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DD1lP/Qm";
	spf=pass (imf04.hostedemail.com: domain of nsc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nsc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id D12566020C;
	Sat, 26 Sep 2026 17:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 197DC1F000FF;
	Sat, 26 Sep 2026 17:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790445083;
	bh=+l/+xlFQ9oYX3AqDOoZ5UJ8jLQiMbyYFqszTxwXHlbY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DD1lP/QmC7LYXQVPac1ZErbOX+o9gC185enlv/A+acy3P/pDC5ujo9X8rUfjkldPJ
	 pHSHH1d+F9mBnfgX1o5XEdguQtswWEoO3h1vMpYyye82Pzp81Ofebc9rm0+H2/yEAj
	 ZUmV1JJTvoVd3YYUEgqmzt2MnYZi+AqKPTZgSG0MNZ+f37aK6ZQ4DGXqbfndr5bsto
	 d/BlkNHkO3ehaXRHohpz/SPENa/i18vrn2bs2CQiK8THJZPujfZ4zC2LJYm7dD3Qnq
	 v75aEO7w1UjPmERPWOFujS6zGWAaO6BkF6QCOFcgPbGzKAKKMFZgqeLYHF87qLF4CM
	 NF+O3+M9SQfjw==
Date: Sat, 26 Sep 2026 19:48:16 +0200
From: Nicolas Schier <nsc@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Luis Augenstein <luis.augenstein@tngtech.com>,
	Maximilian Huber <maximilian.huber@tngtech.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, Willy Tarreau <w@1wt.eu>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	Askar Safin <safinaskar@gmail.com>, linux-doc@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Subject: Re: [PATCH v3 0/2] Move tool for generating initramfs cpio to
 scripts/
Message-ID: <argFYF12qS0REcAP@levanger>
Mail-Followup-To: Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Luis Augenstein <luis.augenstein@tngtech.com>,
	Maximilian Huber <maximilian.huber@tngtech.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, Willy Tarreau <w@1wt.eu>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	Askar Safin <safinaskar@gmail.com>, linux-doc@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
References: <20260925-move-gen_init_cpio-to-scripts-v3-0-99c493f76722@kernel.org>
 <areDq-1iFZUViDgS@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <areDq-1iFZUViDgS@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0ACA940004
X-Stat-Signature: y73d7ci7g6mp6g8iuebux77tic5qen4m
X-Rspam-User: 
X-HE-Tag: 1790445084-785305
X-HE-Meta: U2FsdGVkX18kKrVlxoa4R1t1kMqojV0hTMBIyYbUN+kjGoLyr18CeBzateIeCst5fV+GbVLRpDddndJkL5UtpMiIeQFSKkFzqFTjw5UxOvHeKKjfoR92IvGu8sHhlL3a95zqr6Qk7v2ECrdh1GkrB4Wdv7Lp4MNZXuosinOaiSswETww2Q5wT5Ahi3mxbt9j2tSyoJu8JykGK2FfX4tYOzHed5Xv0WOYngxyRhyKMKiMet7D5U129OmDTniZgIF6WqWDPBA/n+Y71BhLmOMTa80teLRKQPkD5Ku9rduWtl9JzlyluJ2TgdvimrppVYB6uxkJsMkpj0OdTADhxngL+477VLUzBA/yUSLi+JLPrNIH5l80VU9qkGfs9KHVVLwbZH5n7dUN5TxoRttKcAsrlJOYHJjxqToeqovCrQO7Gl8SG1r9a/VGYo6mm/5+9pnofp+GQeOFbQDUis0qdTGiPSJ3xVP8nJGEF1jyXgk8h4n6yMvxzxvxpn2UJuGpptG3R1C3zG6WDL6G4geJ6FWt8VOdFwgZ8iJlFH1Os1mMuyQOu4pFI2BCO4m4En1wju5QkoSFwCz/SmV+squ7OlQv3FWW36aC4ODl9GQ7+qsf2i1tufYNJU+XM6jqFJOnMLki+JMD/EsD6P2JdVfjtw4++2NjNY0a1wmlT4Py2JpPsYNvLwySN3w1mSCHsAtFH82uPvh+EqOxfHzvFscIqfEntJMdtguaoO2504KGhLT7a7BusDY31SIL2FHVAKZ5vBJY3J0wWRyHDlFsW+CCx4LyTHKWFKk+PZjmbLI8+iirAKvnat7l9QJqsOwSxyJceO4LozSs82293bE3KctPZu24TylVSJZB4T43YsEgNgTAQMqaPd7A00C/Z6AOsgkl5JrGmBxHOeIq05wetafGqPMszgXGGzU5S6ZwD6O/AKfHZR8qIww/JrrAXeLpNNjpp3ov3vHirOIL+imZpXgvTBh
 Se9H73vQ
 mzFZRNp9dK9FWjdUrS8VEUqIHEUfRD0CLpDbvH/rKAG5pGgWx1KwzXW6Ko1FY2TWhpJZwjJ6tybZTbUh+zX5iENbkD0qARulveo0kudpPwPAOyvlv2XvtBuoYvUbpLMkifcq0pp0eBpDmfvQ4PzZJts4JbFYKA/SXi0GK26d6xyJnAUZVERJtR3fXksBzyI29dddEXrlNuRzyYTavESY1tiFE7oE61ymTnTykNFPogbypiRLqDyc1odRgeNRm9LpmvG0ucpDmjM08DfFcqKT6nMuIJe7ZrgvydwpAbXxLYCNfQWpMb0Up12BFB7JxlBmfPa296Ytn0uKa2B/bdgstwd0cjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 11:34:51AM +0300, Mike Rapoport wrote:
> Hi Nicolas,
> 
> On Fri, Sep 25, 2026 at 09:29:29PM +0200, Nicolas Schier wrote:
> > initramfs cpio tools had been subject of several recent discussions on
> > linux-kbuild.  Let's get two minor steps forward by enabling a
> > top-level target for building gen_init_cpio w/o the need of a valid
> > kbuild configuration [1] and move the tools for generating the built-in
> > initramfs from usr/ to scripts/ [2].
> > 
> > Link: https://lore.kernel.org/all/20260220191150.244006-1-safinaskar@gmail.com # [1]
> > Link: https://lore.kernel.org/all/aSdrCFkUQup3qb-q@derry.ads.avm.de/ # [2]
> > ---
> > Changes in v3:
> >   * Update various remaining usr/gen_init* references treewide (Nathan)
> >   * Link to v2: https://patch.msgid.link/20260720-move-gen_init_cpio-to-scripts-v2-0-26b7e15c7133@kernel.org
> > 
> > Changes in v2:
> >   * Build gen_init_cpio only if CONFIG_BLK_DEV_INITRD (Thomas)
> >   * Keep underscore top-level target name (scripts_gen_init_cpio)
> >     (Thomas)
> >   * Link to v1: https://patch.msgid.link/20260309-move-gen_init_cpio-to-scripts-v1-0-0c5059b1ec5b@kernel.org
> > 
> > ---
> > Nicolas Schier (2):
> >       kbuild: Mark usr_gen_init_cpio as no-dot-config-target
> >       kbuild: Move gen_init_cpio and gen_initramfs.sh to scripts/
> > 
> >  .../early-userspace/early_userspace_support.rst          | 16 ++++++++--------
> >  Documentation/filesystems/ramfs-rootfs-initramfs.rst     | 10 +++++-----
> >  MAINTAINERS                                              |  1 +
> >  Makefile                                                 |  9 +++++----
> >  scripts/.gitignore                                       |  1 +
> >  scripts/Makefile                                         |  3 +++
> >  scripts/Makefile.package                                 |  2 +-
> >  {usr => scripts}/gen_init_cpio.c                         |  0
> >  {usr => scripts}/gen_initramfs.sh                        |  2 +-
> >  scripts/remove-stale-files                               |  2 ++
> >  scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py     |  2 +-
> >  tools/testing/selftests/kho/vmtest.sh                    |  2 +-
> 
> There's also tools/testing/selftests/liveupdate/vmtest.sh I know of, didn't
> check for other users in tools/testing
> 

No idea how I missed that again; will be adjusted in v4.  Thanks a lot!

-- 
Nicolas

