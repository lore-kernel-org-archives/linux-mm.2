Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 274DDE83855
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 05:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E076B0005; Tue, 17 Feb 2026 00:51:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1BA16B0089; Tue, 17 Feb 2026 00:51:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51676B008A; Tue, 17 Feb 2026 00:51:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8EF246B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:51:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2E5B81D31D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:51:10 +0000 (UTC)
X-FDA: 84452875500.27.48D534E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3EBF1140004
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:51:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771307468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IvdmmAkiQbI8GM6eL5zuHPV2rPVW8fLBTRizzQSBji0=;
	b=aVCv7Thgs7s6V0MB63PlAD5OEm2Ejk8PTOTC8advzVMRqCjztTwjiaxe1zp35alN3/0qzX
	OezRSvVF2nydh9JVS+qSYMJRjto4il1/UbadnRmevyOeQ/ol2UvhE46sKjR7CRMJCT3h+W
	50XZuSvU8iJOvIkjPYN52Uf15tDbxi8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771307468; a=rsa-sha256;
	cv=none;
	b=bGbD1YbhbL4+S31ENsux3iCJsKjpw/noh0dkMwpGoxK5hlghAnb+Z7nhHDImF164M4l7PR
	8CE3ODuE3uociqow7RWfFWcgAUDs09rJ74JNyeSc/Zj2JBDl1vUhzb7Z4mvcOxvYc/sXND
	N7+D/DufAzgnYz07Lryrtt0MZvvoYts=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3B5B868C4E; Tue, 17 Feb 2026 06:51:03 +0100 (CET)
Date: Tue, 17 Feb 2026 06:51:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, jack@suse.cz, ojaswin@linux.ibm.com,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260217055103.GA6174@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: fmhoxmncinhytgdetjyb48dp4h1o846p
X-Rspamd-Queue-Id: 3EBF1140004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771307467-14712
X-HE-Meta: U2FsdGVkX1/Zhm4gV8pGbu6exY3my33K80KTH5qrc2n8GvCcs90MI1eQy6KQlDNaHb5KVM8lciV3jSISis/mxMGitDHvTW/d7UEOXTT6cvTjEb9aLRxjuVAyl1N8uGrXNe+EwEnW+KVPQ3AjZv3pSj8jTKbl1PWCLuf7QKi+laGBM4Jr6+MVMgIaCkip5UO+DS/59aQsoZZLioPvTI8BXLyiE0qI78wqWGywBMrbYG6c1GDSc9F3wSzXgqvUL4Igi+F56jSgFTyWR4+7gA/SQAG1XFme9lOzmEIv1Yiq1V+ufaNMBsfuaRBpNDnxk2tbo2QWa5h9JVEydbJyWs48gvuUNYuk6iI8dHh7hLhLxN0biJVv2nUmO+WctnvmJbbOPTH5v9UHJjwKD9MEVFfCt+Oqulcri1dSpw4mcu60AsdUfxy14q1ssN/maabelvXOGp54x929dV8AtGtOF/s7+ooRJvBqtcbzkQY2l3uWwxMbQnScmHY1TaX8+3pxVLxzzF/+/d3P1YcLXzaTwS/NADi+eESFtC6X14kl9ZvaxVWn6/QBXr50u9yYY/TOfsgNnM/ix5R01SqCnXrAmZYAzh+pPVxTBkT7FuWeIji+GU2oZMoyasyvLnbfr+Ghr4ilkv+UAnnYWO0SzJ5vi2kqKEYzzcPNx9ey6sPjC9i1nTqQ2SLmG7ZBt6mOIJkcm3neQXnXwOQtAWeQjxE+dUDmDVruP5+1QuVXeG9xBOYIbvNn5KJ4HUBhJdCjIcgr7D5B/fjT9fgXZha8BQdy+D2pXkFnmxs4vtOJcj4f6vAzG2utjlRTt2641pHeXV9IuHUJl+Ed9w7nTOWQspXMmTs8zDj6FxZjFXAq9AcsrS3jB+9V2/Ep5HG/W4WcPxJgRYD4LFexZIPy4kKSPcFXLdVm3VzDhuNKWvvmeHKi3u5O0bpv4Z6dilLQzpEYWC7u+n9kxqqnmp/xUUYrcQM+kZm
 3hzEdWqo
 89uWjkAU3oFL/4qnz1eIZFXlOmkSd7mn+9493AFxuJmJWfWsDiPVZ7j1CiL9XrXxq5G+kTymgorFZ1NfkZaSvLlJIMjyN8GaofpeMdcjvP0QYU7j5pp+vhycyQKisiQCCHZ1b/WzhfBa6MGVHaaWQTeNPnjUv7T98WOyxK9Ob9hsMeN8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I think a better session would be how we can help postgres to move
off buffered I/O instead of adding more special cases for them.

