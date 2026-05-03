Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82FDECD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 14:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859D56B0005; Sun,  3 May 2026 10:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80B5E6B008A; Sun,  3 May 2026 10:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9966B008C; Sun,  3 May 2026 10:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9AC6B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 10:15:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E32E9160667
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:15:35 +0000 (UTC)
X-FDA: 84726306630.10.159C391
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id F2B36C0012
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:15:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kB26D3r5;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777817734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YoLu4/Y6To8vmjRfh7km84wvUeDNcP0Umpn2civnYdM=;
	b=vMA86cJlZEE7OpgB7fiqP9+h/mw4Wuta3BcEkgcEVxcZnZahEwcFmPL7SQH+o7lVaUKoiJ
	49LRjXHETdWB2sKFpy8jwa2f4VknzmKpoFoZCQ1bISf/mlolDDCTT7qpFfsbutv5ghrJzu
	LaQQ9uk/LRvBUDdHoQw9rgPub4FrM1U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777817734; a=rsa-sha256;
	cv=none;
	b=xcvW1Ozcly7Cw1Ai4Vyhmo33LYcEoHloYG0KnAx4jIkxlU5Pq1RliUzO0BLwQ6quYRf04E
	1h2yER3qXUshsqtvxDPg0KA/yOMJQauqKTeVDkwqa/r+SvRIwEyXGS0PS56XoIzFfR27cm
	O/BpkyV3c98cmZ/Sez/ZzrQVJK2GiXU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kB26D3r5;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso28935925e9.2
        for <linux-mm@kvack.org>; Sun, 03 May 2026 07:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777817732; x=1778422532; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YoLu4/Y6To8vmjRfh7km84wvUeDNcP0Umpn2civnYdM=;
        b=kB26D3r5FcMFl+M8RAidBso2FFXUQ4d6xVbgFs7GqL2giSRoBhCnAJrxLQJLCB2Mwi
         Bw5JJXFTjpTaNgaMZjVyMs85PYPeu333LBSLy1OgQAweiIr088zmeWBw8dF3tFhReOZx
         yk6lQptBovBmEdFD1luuT8TDh4A08uUwZcGxAU8K5UhlywL4NvhG1q6SBURcgg/Gk05B
         aYAQOGZ8Pwlfd8F8h1HbweqEI4dIRs82j1AYMKNlDG3ymm99UOM2HRYo1nACNW1FlEB4
         RigMN8ABo45HPujsHBKuqlklEUYwWIzDpUm+GwyJaL+p9Xss9uwbfTKzXXINZ9h4/kVv
         yJQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777817732; x=1778422532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YoLu4/Y6To8vmjRfh7km84wvUeDNcP0Umpn2civnYdM=;
        b=PkNlSEYzl6u5obZWIN8pEryBH9unni8/9kGZ5UTOBG4GTUA4RPv2yJEEKPhkf/k4Nt
         FGaxNbrGWykocL8+kZAKBgSS921uCyyrYDB1bOoTM6Q86hDMU1cKNwBlUN9Zj7Xvdyy7
         PUjJSjh0rb3oGX0sQF0myF8RPkLP0UvXjTSW6jkLXjwZhsPR5kmOvLNTOkxn7sCviAMF
         URsgjCPs/tBJy5XIBQhAvu7jFcbeiIdfSOm2I4Dy5a1IYCSrGt2SYB55fAlDkWxqaMeR
         L9d1+f1NY/iDRPMW60UEXX4wjCbPYLoonuvqmOjJht/3WP2XdX5Yu+dPX3q1ch2q9Kig
         W1Rg==
X-Forwarded-Encrypted: i=1; AFNElJ8vVzB7HiF5eLmw7xwGNiQjWTG+g8jnJ6uBjniM/+w1G/GYdQfs3jENlTMkqx902pMFemt4vsWWNw==@kvack.org
X-Gm-Message-State: AOJu0Yz4u2oSbhV0VvSg8n/JiRi9m3XolHExgLRIPktZyGv+XD61bkac
	H7l0K6VzBmzFE/OzH8QWCkwL8BvkJR4npxo0aMJH+YMCP9DpeKIuOVlfIKZxi20FUwc=
X-Gm-Gg: AeBDievMN0bpK/yBxdtR/SuFYjPlJVU7gYRaUFU1hrtLlN9ACLbdz1wPSYAUpTanmK3
	kFAI0Ezqva6C9at6UXpDH8aASCHOueki3ksGak4mZPsOSN2O5cnV5CtZzaSPlQON7GJLbcV6JCW
	JNCjH2PWSUN/vjjVpm7fxQ45s+LyUvRZ8/QMncR4v1aHdyOrMsSidmog0BXba7qfruF0AQ1JUU9
	CEXpAsCZN2i/+Y0o7wTK+XHGb+g0mS4aJaNvcvSt9XiJ6NrZys24e6cBM6xpm/vIFPopaoBsiMB
	CLWforlROfgwRbLByIT5SZSL5pewGxYK78ozBdijifBn0FgqYUKw66DmKSB4t3cs0bZheGdH1nC
	nhhsbB/0cga3zDr/HW1+D/or4xsK4AoV3B0yrf92Zpl3n4wDjvHGfs2nOMZVb/zXxb0Snyi+Umh
	/aFo1vz4D2RFaOplvE2kZ5OCjVTb+8gZ327mYZo1eVXq9/
X-Received: by 2002:a05:600c:4e0b:b0:48a:599a:3716 with SMTP id 5b1f17b1804b1-48a98668329mr118389885e9.23.1777817732149;
        Sun, 03 May 2026 07:15:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8eb75fc1sm208853235e9.7.2026.05.03.07.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 07:15:31 -0700 (PDT)
Date: Sun, 3 May 2026 15:15:28 +0100
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	lsf-pc <lsf-pc@lists.linux-foundation.org>,
	Bharata B Rao <bharata@amd.com>, Donet Tom <donettom@linux.ibm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [LSF/MM/BPF BoF Session] Numa-Aware Placement for Page Cache
 Pages
Message-ID: <afdYgG6d9Vrt3miV@gourry-fedora-PF4VCD3F>
References: <h5ossmwe.ritesh.list@gmail.com>
 <afNV5wbhsFQJLzxi@casper.infradead.org>
 <afYQz3YJdWB2R-1q@gourry-fedora-PF4VCD3F>
 <afaCICnrkTEJN562@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afaCICnrkTEJN562@casper.infradead.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F2B36C0012
X-Stat-Signature: ofsnziwbmxphruk5epjk7eiyueq3ian5
X-Rspam-User: 
X-HE-Tag: 1777817733-829580
X-HE-Meta: U2FsdGVkX18X5RyRZ9P7LQAbeQLbySrJkj8GRoETvIfGMDpuH+kxxUMWjYGzSmrBbgPNf7p5eP9yq/cjm/RdWO9bIdcUryyWay0p9XJIPNfwG3rEFmXjOBnFgNbLpJvQiOsxgP8A24whheCVQ+s/HbAn+3a/9Gs7xNUz50KYfUkkHyLf95ZJ0OSt3E8EwVQJ3XQVIC1H3fzCy/hyP3T5SzE4NAbPORijCzefGE2UYFBTbIayKOHiu/RPvIZHaI4lltuTeiTV8UyoMZCELxaHJ0UMHOC5ifIrSuB5A2JnXfyYK7LFTTSYqCLY0OAVlAILh95MposxqwxgP0z+oV+31RYOYCiEXM1RaXV1Y1fBnkg9PaQBlv/oWGXtf0uC1a8LTdi+XWpgQKz5CSP7xqZ2CEyjA732T8jA8GCLscOZdQj6RQvRgfY1cqNBjrnbExyRknPK7rY61WiPPLHHSOvNUjhPqkIkZw82R3JmvVziXFOvF3croTAHxeLJZ7/Qm85Nx9OifTEAmoOIa4dDWaaJQ5IgHDAVgfuNKepplxVmJv+D/fjkxFtWbR4sXlTH1EwSIO6g/8ic7w6WGb2sWBDddoGPRHGM7D57T0LnD32dtRh3aJo7AMZiiV0CFEgNegvcmobrYucHHqoqGzrYb+KhlKDzj4zt8oqvNB+N2CARbLHtUQd3h25Q0u2mSQA+3two7CXQetvZfhw//MVCMoghPRYV4CYKx42n8Kyl0eSwloBUta6hYd8MojSD1A6rBuiuoT3BYcLAGkcYFHaC9y6NYgF6LaGVb8f5sXYamfnZJSlnRgkpRjgukRjNCjlnyXi/tPenNJwHVIBlHY0XkO1N7SDS2Kb8XSB6VNwAiqXNeNUwej2coby7JWQX9PMkh4L4ObF5CyBWp/pxNJv8S+EVJiUhM7nRP4w98jII119xyHJL3FMeM+Jzzs4cQISfRqUV0ZM+BgpReIYf4/eZQbd
 et6hgIcZ
 EFZ/Wa627t1RV2OTQkzgwkWUOPlO0CgHAhIJGNnwF0N0IjZaKxG7ZHrvQMvspkNA5Tf8pEWtTlGmtswmXRnPr4slggfkfzslXKxxoTxA9taRoVr12Y4ufUouCVfwoNGNH8zK7jXqPCIvxYhTLq/uynkgd5jNCgp7rIRrLZSFu5rwGx/XYWy//e154qiP4nwETfFkP4tKblbtFtpJCbBfUymOYPEWhuHOcB4cVgei9LeEjkkCTA12d3OZygNHm00qpcFTn5rczcGzDRvbj9pj3smdvLXGkKpgTHrYSjVaiKf3KoPxiuMogqd34zViEzzcveUXQs4iTjfmIcrjVJQfkZVADSj3+i9G66KzvXnHAt05R+ti6FCBlEJ/sLXkN5rXXeE2oEjOKM06vA+Zb076nrg9qep0yukYkGl8kSIiYeFNT7KeTnLeAKCYsizqSIbPoxN+c2y4pdUGGpGRwG9AqP5XNlJiJycvtPm6fh3wzuQSiYW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 03, 2026 at 12:00:48AM +0100, Matthew Wilcox wrote:
> On Sat, May 02, 2026 at 03:57:19PM +0100, Gregory Price wrote:
> > On Thu, Apr 30, 2026 at 02:15:19PM +0100, Matthew Wilcox wrote:
> > > Ideally, no, the kernel should observe the task and get it right.
> > 
> > Out of curiosity, a use case i've been exploring is something like
> > 
> > fd = open()
> > buf = mmap(fd, ...)
> > mbind(buf, device_node)
> > /* fault file pages directly onto device memory */
> 
> Could you be explicit what _kind_ of node you're talking about here?
> My initial thought went to something like DAX where the node actually
> contains persistent memory and the fd is a reference to some chunk
> of that storage.  But I don't think that's what you're referring to.
> You might be thinking about a presentation of DRAM over the CXL fabric.
> Or you might be thinking about memory presented by a graphics card
> (perhaps over CXL, perhaps some other way).  The meaning of "device
> memory" has become thoroughly confused (thanks Jerome!) so I sincerely
> don't know what you're talking about.
>

Ah, I can see how the language has moved over time.

But yes a gpu with onboard memory presented as a NUMA node, or some
other accelerator where the kernel is responsible for managing its
memory (rather than a driver).

Probably the use-case needs a bit more consideration before we go
dangling new policies off the page cache - just chewing on ideas.

~Gregory

