Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76740CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 21:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B231D6B0005; Fri, 15 May 2026 17:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD48C6B008A; Fri, 15 May 2026 17:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA3C6B008C; Fri, 15 May 2026 17:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 905876B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:58:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3251040259
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:58:21 +0000 (UTC)
X-FDA: 84771018402.15.B08BC17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 44FBE40004
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:58:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YrySnH00;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778882299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mHSzbEHbunn4Gv+x6uYZkpcvkpdkTON/QAE5a6at5M=;
	b=iCf1lnFhTfNF+jrhsCpq24S90adMpuGbFbxpgglrKlEHj/mODY3icx9R3hkr6VTA3IBjbI
	gxhl6OGVb0gFxvjZdhCfzOMBG3zRVhU2BwKqQNph94Hcaho+Lv9u5V+7a9emlQ8zPrFVeq
	C/aYAbXS6Z8qVtihqXOBT5pMJEfFndo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YrySnH00;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778882299; a=rsa-sha256;
	cv=none;
	b=UQq4b65DWiwoufjEakb06GC/nsU9C4FNtMy59S+Oy03kAq6wDpZguAprwp14cNeUxKq5bE
	0DUUf3JlCYfEzFNrZ4aVGOUT2+L1Ljyt083nlyg2apIMSSa5/ejB9j5ATQok3gePEuuSsf
	N3ld2dv/ime9g8jA7cPbSgAnkyHIUUw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92A6C601DF
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3716EC2BCF6
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778882298;
	bh=/mHSzbEHbunn4Gv+x6uYZkpcvkpdkTON/QAE5a6at5M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YrySnH00B0W1qq5Wp87dlgYi2suFfNd57N2Uuth/vkCX1DrZ3IvFyxISLW0xoIF69
	 hRjENHlGB/3ONaZlglJOc4ukuB0ctST7O4dj+rUVrdlnm1YanBPd1V+Bn1UhoHLW4E
	 JXQ/kS1/ER7ObuNKR8I2hcUCtTBptWdMJXaZCExsraRoFD2Gyjk7NySzzJmUpzQ5cR
	 j5a0wZY7iA7GqaZgUjtc+Taku3bBD9oUOyoWapVjk+PBcCyiTk7K5qE2vYSk/R3eiH
	 nSUWFrQFAEnpEsEBNYMpxB2+u1QHKALgTRITtHr4Lpl3a/9KiTwUTCsF3mm9EJCbKa
	 NZO40x8BvCEDg==
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-65c21049dafso619406d50.2
        for <linux-mm@kvack.org>; Fri, 15 May 2026 14:58:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9u+b+ZOoqWxvObs39aEtrvCgev3tXfyy4CRXWi+1Lka94JBve50R3dyJxlUW3MQn0Gwf2SzWVA1g==@kvack.org
X-Gm-Message-State: AOJu0YxjxnugeyANre873xP/FV5evkzGkOJHgeoeXMQD5u2WEiC/HRh0
	5+1+DS37xPcUmkj96BzlWUR9EU3pMpdoQFE8my/E+x0cSFurNIeRr139jFWgGANt6XvbFl9soka
	cNdCp/N1PVQaTzx/kOb1AIsInH0lMbvz9citSYFOBVQ==
X-Received: by 2002:a05:690e:1517:b0:65d:f308:b503 with SMTP id
 956f58d0204a3-65e22650c4amr5634144d50.1.1778882297534; Fri, 15 May 2026
 14:58:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-13-hch@lst.de>
In-Reply-To: <20260512053625.2950900-13-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 14:58:06 -0700
X-Gmail-Original-Message-ID: <CACePvbXhMm0nzXdTqbF5j57AC_7qOH-hMZ5pB6z0cZFfAixH5Q@mail.gmail.com>
X-Gm-Features: AVHnY4L_tQU_kPqgc-BeGp-d2068VNSoZvM02GkthxouKCr7BEGYMQdDLNaKcrQ
Message-ID: <CACePvbXhMm0nzXdTqbF5j57AC_7qOH-hMZ5pB6z0cZFfAixH5Q@mail.gmail.com>
Subject: Re: [PATCH 12/12] swap: move swap_info_struct to mm/swap.h
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 44FBE40004
X-Stat-Signature: 8kmwjomc37sh58emmnx9xs7i1raxh67r
X-HE-Tag: 1778882299-692252
X-HE-Meta: U2FsdGVkX1+d2Pf4vl15VPQiee+ex/xh+wYR7LKxIIL2do0hZK+8rSXFpsTf17pDi3hRR9VMO4q4L5b6IS2cd+wApNErWIfH6L1BRPMNOaDCaCNbTXBHmjo3FwkkrHqtFGlMMEpILkQRzrFiE6c/Ojp7oAoJmq46pXEowiDjOSghZ8efBskICSyEkyPdU3bqIu+Dfr3QSOfXBxpPxkIR1trZWZXz687eTdJVq4dTh8Vc3WdmX8ru9Yl87+k5YKXeds434zHNAXMAgZ7ROTzYeTU3Ezjj4k9k2IbCAWoJth4Ue3W544tLxfWxo4Vpbaf9gKio4RKNDEBM4cXd3QltWVYMVAZYUJ63UhbJjyNB2DfJLm1hDYNwXbkHZg87vAMce+s4iIZ799He47nI8bDbsg23Arm5kYuFHSbx0d/b5dthh6QsP7RXhffDshyUsjtJc3Nct78zvlmVn2VeMc+D+2YCeB+WRgslAnOPZizKYJAJS54OBbtO78opU44ebt3wPKzYC86HHBp67rRsUG0Z9R4zZq5VERjYmx+yISap0MEXkEG25JuOPA/tIpQaqOChei+wQvMyAuN/FQA6Hdbml/MVDl0xSc48aDlH7n6GadlJVMZvg0CX5HFqFJV5j/9WnOzNmOGu7q3wD+Er2qZ6jLa8xRvwScWXwaKcJyaIQ8PhTNpBFNLvMTzpuPgbJeb3p5cexDpI6zuXWj8Fqa7f89hr5b2mtIz7EfArrJL82Pnh5kyWk8JfyYOVV5J3rfV9NDjtTkpBBfQlCnJLkNJjTlOZmYZOaEBYiyUbQUJCAyEIIYh6XJkOKKBTdRh9V2ymqGreCaO0UoI8DtmlEc7PzPovrtiqd0MXvqyzsh4Qp67IfijDzgT/Wmga7br1ardZYkIOJrfEaEuB6k9Hr+bP9BKkk4hylx+G1OD61dQ7jCB6ri1lByGmdxVd3+QP5b0TjWyjDRS8MLAk9wRN8Ru
 Zb6D/EAF
 zLmiB271EzoCtDfs6eWgc8WCZjJZQK2m5p1kS+qQITvDTsPjKVN04vYmvztx8EtESAAW6esLPVljm08P39na5Ak3ssBmolpmy9XLQ8hNIT8g6w5I1eTweHNMhrk4ESxQkEDHoy4VVoCvznzBcGCmsX9gJCFaUt34/2r0RMsyGsTVRnm56ZxP8CAJgjixOWY101Uy8Pfzp5Vzr5HjkAf7By78JXF29cwliiUeC/LSuCVgrhtEbFK4Z7uJkqaDRqussI50ZvUQ9sXdotUw88QwXliZ+msLzNqMV76gRKZQM2afmWSwpMO0lbFHC/x4C7X3y7g3QFO89gf4/zLfBY6FSoxbsfKYGUIini9g34K6qPNvJgZeLRw7w1/oTHh/XicX5akbvB194JLb5qDIlfoux6MoQlvTL0zOFsHDgvCcCvfShYabw4qs/iWPPUQ293OZz6YhOgobUtDrKLI5o+PgsiDGc66lNiRd0WYNaMJuaNLKzkSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:38=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> swap_info_struct is now internal to the MM subsystem, so remove it from
> the public header.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

