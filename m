Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCAF5606A331
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 12:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lBJKd2gZ
Received: by kanga.kvack.org (Postfix)
	id EB1986B00EF; Sat, 21 Nov 2026 07:26:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A806B05B0; Sat, 21 Nov 2026 07:26:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D058F6B05B1; Sat, 21 Nov 2026 07:26:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD88D6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:26:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3BEDF1A043F
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:26:25 +0000 (UTC)
X-FDA: 85459049130.28.E5A28CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 89007180005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:26:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lBJKd2gZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795263983;
	b=HyqaontKD7B62E59PMy7VoY3jTeLCfhpe102jpDSZ3lcwhW4DPWATmeNJxMTu/3QvmdEk4
	P48iqA3Hpwt2WC4rbPaeicBNWvoFM09vQzLRR4AsDXyOnSDrjLZebRG9EgqBvTKX9NHPMw
	5cGXxafO2KsK2LSqWmWpb5J0jtHKgWo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795263983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0neY9nO3KCbPA/3zfsAmJZKfNu+EcSR5phNhBE+ICg=;
	b=J836PzZePnqKSjGpfkiWmWnxigxMc9OGO1IZ6psy3cLhAdwEEGcHJ/R58+xosIds4MSy+l
	SmfS2SA7K62gttYBUA4MLRprLsOpSY6pLEaK9UCgjWu3QvWYXb3PDNsbq9H24NGIfF2Jgl
	GKlSWdY6e8NTIE8c2QzBEBBS03f/FwE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lBJKd2gZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A92FE42A09;
	Sat, 21 Nov 2026 12:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C998D1F000C0;
	Sat, 21 Nov 2026 12:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795263982;
	bh=C0neY9nO3KCbPA/3zfsAmJZKfNu+EcSR5phNhBE+ICg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=lBJKd2gZtJqmOhALUfIZFUGEvMU9nWGSgsPCQlQVBuILcl3ryODy3jrX3L+5KxaNE
	 A5/UKy/VB9vg4xYZhigz4P5PaLg6q1sMJT26HWNFfUv4AiGMxWPn7/En1V+bzGAWZ5
	 VnEF0dOMlckg76+ITSXFVB4vjFF5pTCqrn2L8KbdQ+SSEWVkRnqQ6/0ZBXkJYcFbMz
	 ftRuhMvhUqewdzBr+hYn/LvI7xnCqMSiKxGDJT8W4F4NOTXhnuQ1sQ2OPsDwmJ0IDx
	 2Rig2v2Ew16plr0Ar6yUMRxKRLYoYEh+XLDaTaoxTeXyM6DEL4tncZsQ13OigoyRT5
	 qgkzmGsCcGG4w==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Nico Pache <nico.pache@linux.dev>, 
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Shao Mingyin <shao.mingyin@zte.com.cn>
In-Reply-To: <20261120-b4-balloon_nr_pages-v1-0-d8944b587819@kernel.org>
References: <20261120-b4-balloon_nr_pages-v1-0-d8944b587819@kernel.org>
Subject: Re: [PATCH 0/2] mm: two NR_BALLOON_PAGES accounting fixes
Message-Id: <179526397954.4537.13435944828068166975.b4-ty@b4>
Date: Sat, 21 Nov 2026 13:26:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: rjxgj1uz4syt5rhfjo5d7xzc4agnxzfg
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 89007180005
X-HE-Tag: 1795263983-704387
X-HE-Meta: U2FsdGVkX19vPZ2wfQKZvHKS7bh7s8r2GoQe+K/w8XcoLTS0lAYrh6FdzeCQdtDEj02gVR14lKUDmXl3AZtS8BTC+VKOXjfet4kaSrkQCyBio72HFv8jZ5+LnEUfEAN8jXyWVzXwZRlhMLE0US6GvUS+uxm1lUrkpmgGWNlC7MeaJzgwzLZDufRCoc99pCUySnrb+ABsyq9ZLEB+6I309NI21WwFSoK9SSTjzdYui4UK3+C30aJWBZ8mKib6WIfoTcJKnKsA70lRZ08pZeS5rUVCuG5CzQY+6MJnHTwz6GLhRPYYMg8iN5vTAD+1rBPACtwdvQrLL7lg7DF43y3hmnBu0wH5vrZbpHZhgEaxXM/SnS9+Y/NkIqhRUmFja4cTzQ1ObJlsK8Q+n9Xd3Q4P5H9lxVcIHR0N6wtx4ETQWVcRIUPvcX0ehM2+lrK11/6290qJZGUw9Wc5rM698JxWt9Tmu9MtW0x+7LgUW5tw7QcfjpMkAVDXu/pPMZ+hNvZiGO05aFKzoZFQUofYHeW3NFcl8JfJMJiX4P990fz3thUJK+Z325Se5GGHg4OFv0YIIIgOBAM1fSOKyEgino2HozJKXj9C7QobR+xQWKSvU22s60tbIr7ZwHMRZgMvlCo0RkIQkkkiSWjsFgiGMImcd/NX7t/HHU9UeH25uLisK+lbb+VNC+PCFqRbmSkCqN4IAX5bv1fFmWwiM7vOPzfumZGzuaHyjsFZP8edUgFMOXcxiObAWGeLXIEEBwPdlhBIycj0OXYoXMUJUkPsZNWw1DEFEpFyaMN8CGZfLFk4LyUQjAAVw/Wypcl504cuGFg/xAQawY3NVHFpy6PMcIuNiH1ReYQIXL8FIsn9TrNggy6BH3xWQta2jbzQHq29Vj/KWjbhdLKypROWt6vewsbhXPan+G0DPbI4dF2hG8r8PboJX+RIeLYVoB9CiTDrEoFasXEbQxkRmcN1B3VcJli
 xb2Kmue8
 44ZDmxrwC15zMEw82TXN/DgMYwZW2MHWHc9Wvq00mnOC4UGuAwlSbUPc6biFZTFlY8n+l6hhEk25WWeF8JmsUJPFTYxgAY4753gK14Vhx9+KZ6Eg1ddscSIe7Q9ei3DvOk4wSKmT0gY8FtfKaYhXvCJsbI9RjbmisL6s0xqum4yzVt9fuo3mgLBLufWMC9/+1pP49z/Jw4eETF6Zp/Ck1KQ92Apw0cpStVmdbHXzHkF8znVn/m7vNTJhHc1NdgCqiEUEzvk1VZuHanVcImlKgzdbGdZXdjMDlJUa7t7yIEuhDbr23eItpOCZ1kjKfhD9Cc9dProEgGiFGkJ+lNl6FtJ4mXqAOL2Gmql77eIjv0JLolxz6GjDKBNb3r52udRQSflqk7BtqyVv9XdWBtOnobk3inpf81ey3T5uaDk9wS/G8NVHAcpKNd25VuPWLVt7wd/yc+FUPlM7Vb+2Y0rJGOmvj+hQ5oYknQ5cUL32MvfSAusB27wX/VPS4IV1pDx4yNBySeZYXMyZkiA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 11:34:41 +0100, David Hildenbrand (Arm) wrote:
> two simple fixes for NR_BALLOON_PAGES accounting. I can take both
> through the mm-core tree.
> 
> I tested patch #1 briefly in a QEMU VM with two numa nodes.

Applied, thanks!

tree: mm/core.git
branch: balloon-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/2] mm/balloon: fix NR_BALLOON_PAGES accounting during page migration
      https://git.kernel.org/mm/core/c/99d23a24
[2/2] vmw_balloon: account 2 MiB pages in NR_BALLOON_PAGES
      https://git.kernel.org/mm/core/c/7e980d06

-- 
Cheers,

David


