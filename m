Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B22360CA5CB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q2tiXcRL
Received: by kanga.kvack.org (Postfix)
	id A6E2F6B061F; Mon,  2 Nov 2026 10:24:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44E16B0620; Mon,  2 Nov 2026 10:24:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5EC6B0621; Mon,  2 Nov 2026 10:24:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 598F66B061F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:24:38 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE9F680169
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:24:37 +0000 (UTC)
X-FDA: 85390550994.23.165B9CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B7157C000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:24:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q2tiXcRL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWdxbpN4QmmVdM7UmPZX8KG1qjYZ0FQqqjiDA/VJnOE=;
	b=NgIlR5QnuRbc1DslS919YsTtVvOK5+lmNw5qbzwavTvmd7rqigVbJmsu6KK52lcALjiqDF
	6uz1nCoahhv+zN3H7/z84d23Dsu2GanvnBzpMG0Qd3CTCcS0GzhCDCctMro1mqQICrW++y
	nMJar3IWr6wsw9mlrP4z9N05kC5akxA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q2tiXcRL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633075;
	b=fftn1MgTofiTXIh9pILRJAtscGp5ndZl/mi85ImSNEWu+/SWnpRx5FLjXCgK+lYuhpaMLI
	bRq+BMIHdcSRPjyWm8uxiSMJW1Js+zZ3vuovwTjkHP/GnXyH5j8w0da3iUV4NH4YS3OqUv
	jD8WUTmioHDx1f3o7bhNu4l+KJ14gV4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3BF44339E;
	Mon,  2 Nov 2026 15:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843EE1F00A1B;
	Mon,  2 Nov 2026 15:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633074;
	bh=hWdxbpN4QmmVdM7UmPZX8KG1qjYZ0FQqqjiDA/VJnOE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Q2tiXcRLjLxp0Sfv6TzxDOmLL749D8GFuBHdfpwBAeD34WSvlzVQOB66VPbtBDtEP
	 tLUMLSHppp9BGtNkx+iY6knlxASDjOHhObUbD20+r4M0FYR3O/t15nxWT7pSikrSQm
	 l80se6jfpCXXfVSnxGTpz5QshYCbpTErxlP3n0HKQQkJOPoxQWfQETJzTk1O0FgEqa
	 NmFdXlbeNn2BqDteoBNofMcN77X42d6NxWhrIvHLottL9yHP484r9SqFFyzAriZyEL
	 lYmT6OSXrQToiPByeQlZYEnbo1BZqOcbgqlCBnqZcBLQRcB8vex3ik09oALFFv4tw/
	 P9LF12YhVou9A==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id DF743F4006D;
	Mon,  2 Nov 2026 10:24:32 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 10:24:32 -0500
X-ME-Sender: <xms:MKvoamktWPzVHfGfqMnfBUnX12mAfqCNpYg1mnZpsjjQlytnP_GDFQ>
    <xme:MKvoaop_snACaCPsp8UbIkrX0VuTUqCS69NZfmyEg5VuQEMOwP74tDssm1mbMC7Na
    L4psiUcO7zb92ZqJJXrSnVU02K155UK_Jvir1-pnBpDMj8LrjlTIfw>
X-ME-Proxy-Cause: dmFkZTF7ntWmEwgGBlbXwlipOb1DEBDQAhhX0OL7W3ESE1c4Y58F5UnDJyEt8dnhIEkW49
    bSUNjezLoMpeptFAstes/dup+GOJHwOWVb/CWlJyXGn193f8h3l5hsZNShVjOQjsTRohCX
    A7NtHx/zL2ejOFY7nM9kfOFgoikYlrAckYOu8f7hASCDsja6Hrk1rI2T70O3iMDfg2SxYY
    Zur9L5i46jczvGC4EKxzEWA1pfFm+yB6AEfDhOzVlEFraYBZk0g/TI7U6Rq0NVJniUPAx0
    Ms7uiqAKvKWNclTSyqDyA2iZMVN/pSNwwcfh4DKH9umqsend9fzIPoI/wbZ2BY53mtMFZy
    zDHyo9usdkoEZaEpmTNoGa94y6UWs06X2+Vvayf+hT5Q00wB62DyIvXiaKtIAqQyvgezJX
    gMQyOIOZt2s0Ka06QtKc3yinHtSyP17AYeV498V+x9QPrcYPy/IjcANtd5PFTt0p4ZP/mb
    BYBzvQSBaIjqqrl6pc9hfHnF5W5BzvpNOjFH5WhHliptZEM76ApxkAEWqTQikHqy9MLimT
    SOmvYcd4EnPUd4aMEDJn0RYBZW3qZ11uB8PJIkz4XPQ45DzjQhNh88B7wEg8tgVl/zJsOZ
    8EVVdmAwwXqghCDy2L29cKu7oFIfpgdJuXdxVYsukJyDY7oGAc97hUYTlUrg
X-ME-Proxy: <xmx:MKvoahKh4Qxz2XET1vMc0TgeYLzxxsBqS_5-gXCDYyuzFKNMCpL9Gg>
    <xmx:MKvoajCApUsLjsSQE9T0YLW3NG1H8MteSFyAcNeQhGG7lN4po_K-oQ>
    <xmx:MKvoasLUqk4CAxihafDuvBm16uXYM-rD8PxB1Cn0GLv2DlrRcrPt0A>
    <xmx:MKvoajioD5IUkBoHBGTIovYDFn5dB2KnImSD1Ef9OftQO8lfEDDkGg>
    <xmx:MKvoaos93Fcbt_R095IT3GL8KWMxtU_fU-6c7khNrkI4NMTo4hEWeMfk>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id AE2CD782738; Mon,  2 Nov 2026 10:24:32 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AG7Lg66T4xgg
Date: Mon, 02 Nov 2026 10:24:12 -0500
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
Message-Id: <097f592a-d943-4740-b99b-8983527095eb@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-fs-v1-4-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
 <20261102-work-procfs-fs-v1-4-d09a996317b3@kernel.org>
Subject: Re: [PATCH RFC 04/27] lockd: let procfs copy out reads of nlm_end_grace
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B7157C000A
X-Stat-Signature: e8a5mfo951zbemq4fss8ip36de9b1gxb
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633075-742149
X-HE-Meta: U2FsdGVkX1/gn5K0Q54noxjj+IKBWSM/EBFYGayo3ZXU5UC6QkdvT1ra5xledVEzdLI0hf48SGarXTjSSCo8ffyBxqdsGDXpgkYp6jjUi9uBp57M4CyALuBf93VxzMyVCrPslzyCg9l9geON0tIfYTUYLS/5wVfZTaqDNEEuYtsEpwPn2D3CT775lInRiRMzgebRPO6y3wsQMQiMGtsduIq2uxwnzJE13CuuIjbY6rROULzKLQAW30GioncffVzEk6SMaUOYjOM5RcvN9UDOMcFabUj1yu8vwWLBDM8Bm2O5isC/J6Vw74RyBBqVw9FuZqPJdDLJ3Q3SNbRNpD0w4LX9Eo//yWY8/W+nnQfnPurQZMLxWLTtKlEkMQCWxmxI5XZud/UTfWOxQuSUEJvP/TM0AUcsb1EoLbReFToBVS03CCjnXzgMXWZJp48B9slFs4h9cspxP97XkvUJ7Y/YQ2o/HvfgHkP6XSHWGUPjFJdmK3F5nkAoA2Xb47//ioSr0jlkCjQUYFPtBN+tmQIjkjkMk/P4cMXexxuJhcDmUp8Bsk7q3MM8O8BLQ6UiEOka+tbpv0XodYoccljH3iC/WbqcimZr2hzj+AV2vGZsUzcS7uf6BMzvqY0vgi8StvcWcVLVuNJw6xKaZX0lKSmHcrMUVWQXe2F+g0AMM8yqYvsLkh4VJYcDfOt7EpcwbnTSjgKHCNR3QVht5Em2DNkXSRzh/33JbllOaaiGOEg7cbgjB5h4pDvuGCE+e6+74yHH500E2+AtJuQ0yKkFHcvtDADOZOVSMP2/44d5fLoRDDVHUJlu1RHkqnrron+LRHZuDMxr38yL11W/VB3OUPC78IAchwmimvCs43mstkJEFChN1j1GK8A/yQrjOYGLZuaZ2NxMKFkhiYmtFKkFTyY7Vvhhp1uLR05jfR26Pr6kkIZK1wAmKjVZ4SdQxcCoUlOMRG+8EFN34GO25yqezPG
 NOcDnd7C
 l1RLqSxfVVXuOeQgnt64EeiTgO5AJkf8J1ceFQ1moANY9cLskurkjYTNyf1w61AR748WLybuEGkzqvjJSI7rwbgVA2sw8LD+B3ndPzvIivuf0vur4ntElwzN0v+t+o27z2U0HPU454qvx0Nd8a+cfy8oWo6AoxucjmnX+MAP8y0vUsqdVBh1jOUgq32D2DQ+lHSM7fm8wETWlBVYVvahIsDPZ+quJy/zWjsjIP1GWUOoegpdN8iA8TurynK0gSvtxzAoNAnDnS0FANGqSPhPRJV5heZJPCzyasBrbDBzpRTBGwQ3evmEaPpPmpjUHR4Co8wa0ByL2KsaoXfmfTgFYE7OsSwESLToxIKQy9DQ1TQoz4owgcISuqWk6f4keisty2enjS0fhAGyCffv+zgUeJu6HKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

