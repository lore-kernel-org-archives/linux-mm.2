Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAA0C606A330
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 21:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQQS2O2A
Received: by kanga.kvack.org (Postfix)
	id C10C06B05B7; Mon,  2 Nov 2026 16:15:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC16C6B05B8; Mon,  2 Nov 2026 16:15:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89CA6B05B9; Mon,  2 Nov 2026 16:15:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84FBA6B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:15:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A430E16028D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:15:03 +0000 (UTC)
X-FDA: 85391434086.21.B39C128
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9BB93A000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:15:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQQS2O2A;
	spf=pass (imf25.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793654101;
	b=Jx/oKC+sB+EA6nAbU3LJFqVfQHnhS+9kPGzm0vuxnrFMsfCKmYAvR4uLGIWvJ6rCEvmyap
	Y96w4YjRlfzMy6F+1bv6Js8WKmBucefudNBRdwrw5s3N0O6DtrQDZWwMyEkP04GCmAHbSz
	yf/brVjVOS1O2XWC32oMAcmZiJgBwg8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQQS2O2A;
	spf=pass (imf25.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793654101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IboT5prE1F2zgLUjN3M8JJkwTsSKYt9w9Q1ZY5Lm5jE=;
	b=cN5Pq/+izDHwFUoSVI3bqDtFuNphpWlWAgm4+0W0O2DwlSl6R2Cc2/Qkj8FbSHTHZuZ34t
	sVZtP+RPJI5w9/Zxa67VPoRrnvXy6UxL91RPhZ0F96J1nZnWjFjeRYB1QZRXrRRakEJEQ1
	Wex1wmN3UF4OojnCkTcECEcJFTEZsWQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B1E5601EF;
	Mon,  2 Nov 2026 21:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B7D1F00A1B;
	Mon,  2 Nov 2026 21:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654100;
	bh=IboT5prE1F2zgLUjN3M8JJkwTsSKYt9w9Q1ZY5Lm5jE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=iQQS2O2AfQi+b0NdK1c/IizthlwDmBEQCWvAB+m+GRkBQynljQMNycIudYc/9h+f7
	 Vawkm19O3oDCTmBHyvNQu/VA+okB5t8Z9fKADvjwmVYg9kIDcYS0RGx7iOgEusCIt0
	 sSUI2zMCBo8GTTgwELt8DWSNAXGAXBVX+K5v7+akC4NonZ2T53NHL1PfwdD1coLE4T
	 UgMKhDsPZNnCe/lwhxhJk5/Y/IQS2vyCvDzuusO+IC/e8MHzZliwnwssfEHb72ld6S
	 NYbu/taiK9urXN1VFBXtl6MzT92tBVkBKu03gGwf0I/CNsbIMUlES7wZk9EI6GVBLy
	 iYqmaA0XMCbyQ==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3FB84F4006B;
	Mon,  2 Nov 2026 16:14:59 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 16:14:59 -0500
X-ME-Sender: <xms:U_3oagUAPKL0KahIhejOYJwKEPfYb6twqYG_HHugM7_eLn8Er-TgPg>
    <xme:U_3oavZTuzGHMfK0qXbinG0nc7CYskrIhJQ5eHOz_Ha7XvQtwnXU_T7hJPsGo9qg4
    BhXiwA3Pdzj3QiIOE4JzHYJnc55BkwZtZcinLkFBcrDsA6sylLxQvo7>
X-ME-Proxy-Cause: dmFkZTGSCWblgfsMhzNjEIN00ph1bmXztXGhYrK6FQCSJysx8m5mqsCTJHkCuZD0tpZuBG
    pYnx6qST1krVMCyjpYhoMBo2TltjSYVP2LKGOkZnOBb4t//k/nGoJ/SIXKKJyIATQl84il
    BuXRlRV3aPeB88TAd/llIDq/9PMZ1EzorVjUV4ox06mXS/IOKUqdbOTFcr2gFtJFq3Gx7F
    Zq0nEujwlkDiPcDOX28riG6oQW7iLTgD6BaMnfnV9H0ADvTknFe8adm4EFa+o6I1mSuG3K
    LJ3epAVfTBg3DuzNRu88aZuYWYeuI7KoVJah/eioVIkx6sAoHZjqyTVRvcNhYqHYgvNdOh
    F7RoapMXPpPy7fnRDGp1EnOzRafp7mYLbQvUWevKonPpL0zVugnrni/xwOB0ZUdq15K6LL
    U4eIWAyGEDjfaCYO/Dppo1HoBBuP1Ugp4Zki+kXZHcTkA1gjEQVaV70KrwrPcut26vPd/h
    q5yJSVyn3x/Ch0xklWbVCXPbWoaIS17brwWPL/guaVzJxizQ0P/jgX0plm53NXTsLd+70V
    110yVl467ZsRMKGBWdC4JnWQHbcxAMHjeZkhkyAsfOuCVSLebxwzvInrQKLcoImyb5UwHY
    pO0Oc+d4/j2oJCRnrCOkOe51eLIclfMVgyBLq7y/6qqZiV8XA97NvuTzr1lg
X-ME-Proxy: <xmx:U_3oatxqYhX0hWpcSGJgdTO64UmbQLn1zkSvkgmn2QN3P9YNu5WJ0w>
    <xmx:U_3oav5HgW2k6KeJbHXAdQUNPTjXcBKAkESvLUwa5JME7gNZc5c0tQ>
    <xmx:U_3oasSgNqIt2BaGeBZ12VcERyFoy0lpk1cdl0eiT57vWKlvWpphXg>
    <xmx:U_3oaifZ0cTDaYHT72Jch7KjTqrgvVpyqwgckwFzCeMt7Uwl9HyKaw>
    <xmx:U_3oapwU7EvPML2sBaImLYgTk9SsDSGibfYemkcHEOBIYG1GVrkdWT-b>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 181AE78273B; Mon,  2 Nov 2026 16:14:59 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AlKaHQIBeldV
Date: Mon, 02 Nov 2026 16:14:38 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Christian Brauner" <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Jann Horn" <jannh@google.com>, "Josef Bacik" <josef@toxicpanda.com>,
 "Chris Mason" <mason@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Jonathan Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>,
 "Greg Kroah-Hartman" <gregkh@suse.de>,
 "Joel Granados" <joel.granados@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>,
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-s390@vger.kernel.org,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org,
 "Linuxppc Dev" <linuxppc-dev@lists.ozlabs.org>, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org,
 linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 "Takashi Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org
Message-Id: <961e7e3d-2117-48ee-8a7e-a7a851ec8ef8@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-fs-v1-6-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
 <20261102-work-procfs-fs-v1-6-d09a996317b3@kernel.org>
Subject: Re: [PATCH RFC 06/27] nfsd: let procfs own the seq_file of
 /proc/fs/nfs/exports
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gpkd6k6y4ex5qm7q9ckeb71f1ihek47g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9BB93A000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793654101-840217
X-HE-Meta: U2FsdGVkX19JfslLbqJfAU6t+YUW0qzQ9q3dZT3FLhfyNe5RPw1Ikn9piTdCoXWrCn/Q3Z4NUy89Ep/v9cK83GW/r2tgQP6ZlZvAKvr57G3Ai3jRMMIrh5PTzBpCh2PwdJ2qFU8YgNST48HVLNRuAZwTZ7iAtJ/jfl7LYA6YuICZS7W/OuR1lhmczpU7B4WstGDCcvh/7qbnqk82TgUqZo+0brsJxcvx97JkgXI/2oSbzZ1STMBeqmLQuW08FKX4amA/1WQuUYewPdFZ4gsLXtI5dgsfpJ6QPtgNYO1+tXMucEXzNWFejfJ5fc7mkMLJ+tBb+Q8keXtaTnjs4QopfzPRFhU9QI1O81e2scgVicsOWS7RWUzkpwgrplTbEVQOVE2kQ+zw74QILY6YGYv70YAqZI4ikVBT8n0r9BJzmObF6F0+lES5k5vuQVBGTmT1dNMOIZCVX7cxbN3Gqe6tdGt6MnmnU5l6Ho1BbPO7b1GEv1SvcK216J8j7UZisaafZfuuJQv9ZQNRb3CVvd+4TewHYnU8PFygkkcpEKiuL57X+v9A7Q81Zfx1qLn0Qjco8VjC5Nu2zhgRhkJo6K5iKOpzNNRJUm9jExcNoIsYQFSZqnxGA7QawdvgP4S4mnou/jswr2ecXhqXt79ZrtRvM2Ae7iz8mh98LKTUGj0eAdC67V5iNvlqakToLk1LVKHAclIReKrDjm5LMdCFq+7TDddne8CEBLLSB6LiwYa2p0u2r7nRDB6cKVly2InJQBKwNC6czU5pnUm8JTgu/TtxxaHqlZ6QW0xLklhwK9Q7U44y9Rkf+orLHcKhe2lq4byvGz65nyo4SPGLVXPp8pDFiBoBZcS1XlcObf4nevU/PG9/+mBtbLRaDRCyi7U68qgVvyfhM/G3TrQOdzIKn33WJw9EUVpQYymGRGsJKFkkpEp0ZJa4BMEsUDJDdOvf/6Sxgy39UBon3Zeq1yTOYyh
 0AAwaqlE
 keu6XpgmxRzywRPFL6uib0VTuCkIibi6sv2plkL3+HdDJhivvjwcVFRann0HJLFsutPWthpk6Eg+BbhXr45m/oXU3f67hN6Slc1VufGVKVkPbgCG0tv5yTw70XJ2B6TTbN5ofJhGXRFsgrT862vg2VEIdNBbnqz7sQuZgoTR9YG7not+O2FS8s2O/G4Zztl7dgGug5WAgF+8i3CMA7qHPee8FJNFmSeuD3VbjfgklrOIEPIj/B6j1tcbYOt5glx1xLTBetyCD0U27WHO3Lq70eit+1+T8Im7GR8GwOERpW+PbAozruYDKfuAUgdEKprcHJePxGJ447LFzN+jkW4pVhCSjDLPI5/Xb7WgNPWuTkQOpAOKk6bGBYStfZqpm74wS4ZDv4Yxsc61qIXwH1JfuLuWCuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> Declare the seq_operations and let procfs open and free the seq_file.
> ->proc_open() and ->proc_release() only set up ->private and take and
> drop the reference to the network namespace now. Reading the file then
> no longer holds up its removal.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

