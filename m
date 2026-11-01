Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F830606A332
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 23:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=inria.fr header.i=@inria.fr header.a=rsa-sha256 header.s=dc header.b=hXM26/to
Received: by kanga.kvack.org (Postfix)
	id 447456B05B2; Sun,  1 Nov 2026 18:54:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7B66B05B3; Sun,  1 Nov 2026 18:54:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E97C6B05B4; Sun,  1 Nov 2026 18:54:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 080346B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:54:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8322EC0B4E
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:54:35 +0000 (UTC)
X-FDA: 85388207310.21.127879A
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	by imf31.hostedemail.com (Postfix) with ESMTP id B8A2C20002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:54:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=inria.fr header.s=dc header.b="hXM26/to";
	dmarc=pass (policy=none) header.from=inria.fr;
	spf=pass (imf31.hostedemail.com: domain of julia.lawall@inria.fr designates 192.134.164.83 as permitted sender) smtp.mailfrom=julia.lawall@inria.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793577274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BlqBpaBiBIH3lx9LCXT9bYsm6eEmk51QgXtyvSdnxRE=;
	b=Ph6Jn1LGC3EbjM45aSD98O8s+kaMfXQQFZPzdmBu5icoXRygH3r2eWUwBEsqKJlID2rdUg
	v4tfegDFSiEaVvuYMkJDbWTYPL0f6yoogoqirVOq9BYmdlf3/gcL2B26sRsm9+xq6KC81V
	j/CuhZ+8z+C/0nNtyXihxbXZGBI9+Dw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=inria.fr header.s=dc header.b="hXM26/to";
	dmarc=pass (policy=none) header.from=inria.fr;
	spf=pass (imf31.hostedemail.com: domain of julia.lawall@inria.fr designates 192.134.164.83 as permitted sender) smtp.mailfrom=julia.lawall@inria.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793577274;
	b=0YTrQX8R1/wuIK+gPxoGFIuK4rx7nkYGCM7Vw3QAZkggZCT8ICrm5L1/hvJojEm1nVk88s
	BU6iMLR74BgwadCSOJnjIe/K46dimPR/sdYvHX/hfyub7/052Ghvp4uTRypACiAZlJK0uO
	D3Zu/AS6g8/3/wJcUN91DizGQnr9dQU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=BlqBpaBiBIH3lx9LCXT9bYsm6eEmk51QgXtyvSdnxRE=;
  b=hXM26/toW/dGBf8YdPcVB8v1CmTt3tQYL4Nk9ZIAB+Wd1KIRUgXXbIDR
   Q9NVch7ziYUX8zSunSDAB6W1Ua9j+0DtBRbG6QTmfYxNqx8z/5IUU+cAB
   VFttaM4t7h0nCnn23XD6dymTUMC4rxVY3iG1TX9n7wU0vGhfi0Q4cSFnf
   4=;
X-CSE-ConnectionGUID: 7Vm0An2ETui3fCCnKWyczw==
X-CSE-MsgGUID: E/l8+JRzSWC0WBlBdEXO9g==
X-IronPort-AV: E=Sophos;i="6.27,190,1787004000"; 
   d="scan'208";a="303236812"
Received: from 88-188-149-159.subs.proxad.net (HELO hadrien.home) ([88.188.149.159])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 00:54:32 +0100
Date: Mon, 2 Nov 2026 00:54:31 +0100 (CET)
From: Julia Lawall <julia.lawall@inria.fr>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org, 
    oe-kbuild-all@lists.linux.dev
Subject: drivers/hwtracing/stm/core.c:509:8-24: WARNING: stm_fops: .write()
 has stream semantic; safe to change nonseekable_open -> stream_open. (fwd)
Message-ID: <f887f7b3-b72c-99d2-8dbf-96cbd83774bf@inria.fr>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: B8A2C20002
X-Stat-Signature: msi6pr98dy5dsg1suqsj1zxjo97nwzsb
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793577274-711503
X-HE-Meta: U2FsdGVkX1/8FHqCmQIvNYtybu6q8gwM5P8bNrLwpsXHxd6E+/A1su1yzQNMKv9p97Tv0fA4iCQBdmLBJ7XUDo1MuE9RIZ1Wes7hOkWbZajbh18Y2LWHqco1NjSNY5BfU6+/6Rojlq8gZW3sje0upB598GaP5e4G6G4I0LpYc0eEUUEHXxvbn4qz1b9JBZWtfGHNWvlyzGQ4bb4vocujtzbSqIepGwZrwdQp78o+S/0U1ic2pGT5QdmLla41kOp2I/ErQUbN8C/rOmh63EeUAwV/uZmlfSWf2JT5wkhRfiEFiVx+2VU2QdHTmtHu/pcy3OdQprhZ4w1mc0T2P9rr6q5M6MJ8v4XKITLQYCeA0NcN1De1+5NqxjPH1OBKvlVomIgsr8ieiz/LXLZbvOrsRqOXTTdYktyMaJwtH2Fl4A2jKW6bi8XWgOT7wnSDuAW6rIdY8s2LBTy4O+UWKu+QakZdEXQ83SwTXIqHOEI01VLRgN/jJ5Pvi1Xim/Yy5mIXW6CfD+ZyFisReGCA8nHGkm9WUu/TN75PtklezlHuBIeGuLzZtTHXn4d6iH80A9H4e3gEw0sY3/K6YefJPfDjX5Z03IFmu1oftuHSz5xCfa+Pkk16NKgCkmZJwhKok/K9Xo1k9tZ9DocF9ZDXxnf7WKTbjrhm1H1T3wJsq1CIGkKGrnG9fYxLgM732DZCC/6Vc0Zn5vYfe76b8jw47F1mG4NxF8OzIr3QTdTvOroAAc7c2QU/OhmZPwvfcq4mTQAIMFdbLP5A+JXRcufJ96wlhF6yRGPDfdKbsFjjCkoUcntDiWe7+vPMjqzT3jEY6Cf8qWQnnr0b5eTBqm2sm506qknN3ZAUqRLm/KlM7v7/LWRkdobepaOnJXy9VU4+KX9n+6A3WphUSrQhIv/ZpHZVIFXT4WZxOAXVNislUMRkOpZq03Nc3iqZtKN9Kz/LbsekNBt7Fjss8u8ipJwX9ZS
 XdnL2Ujn
 xz/wgqK0StGzceo7b4tkoaA5uNyZiaSAAQSfNG5ED/3rg8yauP/1pqjpuEKv65hPNlrEYq1CGlQKZngZHw6Ankbp5An0g9pNNw2WJw5X8dQi5DckC2F2usUaijYBEJRacjCEUV8JaOeVBn2HscF933d43yZtb0AnMmgmlb5MeZcUdvq9n8WzRRxRnrZpr0/MLeOOgZqk9xLywqCoIbNYx5KB/pCyclqllhLHqUfS6zAF55TAbsxTX5KiLTim1p2iFOYoLWoSQLm0tfLI6s6hlfA5lK55yQvMwoXHGzTtqbiNHV4AVXmOVoEyGtbiHybFsTIBpps5vOtp2y+g7EMHkc5t8ry0mQMRG1C23kaMrJPhUTnbUkyItNCaiTaxvibV6WuOKAeqLL8EdIe/zE6MPGpO9S3LJOheba3QcZ+zmHl/libjjI+YaBxfTginQAEd1dSCMRc2UpPp4gTsseZ7LnPfPm9HF0j8MFrGTiApjy78b4DlWEvfq9VX8wLLtZlpXm8Q8N/KbqvHue/crB8pO/T9A5XUtGt5kGgR0vCvZ1sZtsS59i0OTLMBPT0Zj8O/BBWJFkuosGLJX2Z+mSTdSIXfWCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

just forwarding.  I don't know anything about this issue.

julia

---------- Forwarded message ----------
Date: Mon, 02 Nov 2026 00:48:49 +0100
From: kernel test robot <lkp@intel.com>
To: oe-kbuild@lists.linux.dev
Cc: lkp@intel.com, Julia Lawall <julia.lawall@inria.fr>
Subject: drivers/hwtracing/stm/core.c:509:8-24: WARNING: stm_fops: .write() has
    stream semantic; safe to change nonseekable_open -> stream_open.

BCC: lkp@intel.com
CC: oe-kbuild-all@lists.linux.dev
CC: linux-kernel@vger.kernel.org
TO: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Memory Management List <linux-mm@kvack.org>
CC: Suren Baghdasaryan <surenb@google.com>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
commit: b0085cb94d2477787f4197a3000e33aabf3d48fc stm: replace deprecated mmap hook with mmap_prepare
date:   7 months ago
:::::: branch date: 2 hours ago
:::::: commit date: 7 months ago
config: mips-randconfig-r2106-20261101 (https://download.01.org/0day-ci/archive/20261102/202611020009.xkUfJUpm-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8f6b51ca8bab1d49006ddaa042bc7e4e7306975d)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: b0085cb94d24 ("stm: replace deprecated mmap hook with mmap_prepare")
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Julia Lawall <julia.lawall@inria.fr>
| Closes: https://lore.kernel.org/r/202611020009.xkUfJUpm-lkp@intel.com/

cocci warnings: (new ones prefixed by >>)
>> drivers/hwtracing/stm/core.c:509:8-24: WARNING: stm_fops: .write() has stream semantic; safe to change nonseekable_open -> stream_open.

vim +509 drivers/hwtracing/stm/core.c

c7fd62bc69d022 Alexander Shishkin 2018-10-05  484
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  485  static int stm_char_open(struct inode *inode, struct file *file)
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  486  {
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  487  	struct stm_file *stmf;
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  488  	struct device *dev;
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  489  	unsigned int major = imajor(inode);
a0ebf519b8a266 Johan Hovold       2016-11-18  490  	int err = -ENOMEM;
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  491
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  492  	dev = class_find_device(&stm_class, NULL, &major, major_match);
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  493  	if (!dev)
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  494  		return -ENODEV;
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  495
bf4afc53b77aea Linus Torvalds     2026-02-21  496  	stmf = kzalloc_obj(*stmf);
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  497  	if (!stmf)
a0ebf519b8a266 Johan Hovold       2016-11-18  498  		goto err_put_device;
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  499
a0ebf519b8a266 Johan Hovold       2016-11-18  500  	err = -ENODEV;
cde4ad8368840e Alexander Shishkin 2016-02-15  501  	stm_output_init(&stmf->output);
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  502  	stmf->stm = to_stm_device(dev);
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  503
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  504  	if (!try_module_get(stmf->stm->owner))
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  505  		goto err_free;
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  506
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  507  	file->private_data = stmf;
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  508
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22 @509  	return nonseekable_open(inode, file);
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  510
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  511  err_free:
a0ebf519b8a266 Johan Hovold       2016-11-18  512  	kfree(stmf);
a0ebf519b8a266 Johan Hovold       2016-11-18  513  err_put_device:
f7c81c7176c72c Alexander Shishkin 2016-02-15  514  	/* matches class_find_device() above */
f7c81c7176c72c Alexander Shishkin 2016-02-15  515  	put_device(dev);
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  516
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  517  	return err;
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  518  }
7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  519

:::::: The code at line 509 was first introduced by commit
:::::: 7bd1d4093c2fa37d1ecab05da3c9d48ea2af2264 stm class: Introduce an abstraction for System Trace Module devices

:::::: TO: Alexander Shishkin <alexander.shishkin@linux.intel.com>
:::::: CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

