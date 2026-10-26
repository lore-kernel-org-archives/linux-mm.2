Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF20606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qw5F9F+1
Received: by kanga.kvack.org (Postfix)
	id CA02A6B05B2; Mon, 26 Oct 2026 10:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28A46B05B3; Mon, 26 Oct 2026 10:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1D66B05B4; Mon, 26 Oct 2026 10:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 879036B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:24:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FCDB1207E9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:24:49 +0000 (UTC)
X-FDA: 85364998698.15.A769F37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 549874000E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:24:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qw5F9F+1;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793024687;
	b=KRKrgkJ6iWXsdNhguPkUiu8Px/lpWhA5wUOGbEhLaObdAs0fqvtgvqHbNGLHbb/dv/RO+Z
	OrEGKUQSU8J8ckOVLSQ/xofi3CIySLro+rb84ui1KqO141mYvjV7N5ZuKzZYBNBGrdg2aO
	OiDxO8DMcNfXFCw6BCfN4cOgcLnFAVg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qw5F9F+1;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793024687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAM1EalDUG4WlKW813AOK6MeXAO5HPHD82lWOVCFuzc=;
	b=fUkowjofyYW7oZ9+HIHRW0oPRnocecOrMkplzZQRPbyP8XmSwOqq4QQHMt3nsQjkEdpViP
	7u4as9o22QOo7PnQyiO2CaofemEYlRC8ygau/ybZvxQOIey1X+NfGEUtzpo5dBbWDbw8ap
	TQah2SJJT0r3Jjbyb1AaLTQYWLWKNZ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8260B40AAD;
	Mon, 26 Oct 2026 14:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D171F01829;
	Mon, 26 Oct 2026 14:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793024686;
	bh=xAM1EalDUG4WlKW813AOK6MeXAO5HPHD82lWOVCFuzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qw5F9F+1bzQh2Jmdd11SsFfbmtaWx+5x+ryhkdk5MfzA3ND3OhkbXK6J5zhyhSmli
	 3IuaiJrtvXpUZ3ZhJOf8218YGZDQgl+8xRdyJOwq3WiH18c7ka4Ru0WvqlkE1h3ep5
	 +oa4sitJevsb112yURcRo+pfUjmKlMtnfR4xf8rLvAsozXWRe4zDGgoYdtESQiu4+f
	 HSF6piUolHhKT76zrqWJF2Zu28oeY8FH9Pi3J3C2KBMWF9atUSZshYc8P3LWT18IKG
	 SCBYE9TYwNw6+vUoPmXxi/b2SIFJOmDoHynBimOcKsSZl6GGcorf6JzKpRIme91dH0
	 VLZZFDCBFqXyQ==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Docs/admin-guide/mm/damon/stat: fix pronoun agreement
Date: Mon, 26 Oct 2026 07:24:38 -0700
Message-ID: <20261026142439.149739-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179301327249.2.17530814278215474568.damon-docs-grammar-2@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: chxcnkxdmpkfp1xcn34creydnk3kdwhg
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 549874000E
X-Rspam-User: 
X-HE-Tag: 1793024687-178502
X-HE-Meta: U2FsdGVkX18k2+AtdJT17E+8xIedpjELp4JYcY/h4SdrrEsTQOqTTThw2r4oK7nKpqCNzjnV1U6Wim/dvWEAbXYxwoQlK7owVKc1f7esfjgUt/cnn7/lXWCg3NtRvD5e+aCF/I4g6OL3Q++QhNkRtqddx2A58YWTQ8oKyNG6VOo4GFyR6RQr/ZaOs9sAD3vPAVYSG8pJScGjj3d5Y9o7AXD/tIn1DtqoRj+i9OGieC08Aoujv9HXmDih4PyBTclJjVesAB3GVLLiOjHPVnbGUSHHGS6rM+8V1fjgPTUDvt4WkIMXOzKuywBFf+7cTYgAGZuQAO8/h+bEhQX7RUyCFSA0sin7s76QsgH1k+rdElnd/bfzADGSBEbCyiBGDGzrNW1v0MmqNy9Jw3FaeE11SSdq0GbWBTWtrrbuUn3zkzNuze9lm665MzLwK/tOhh2dA/TUTSN7Hp/lmwrEmN7Xl8vhFIlNMAbO3K7TyV7IW6TnvTaeRJGJnApIx6ewRdBqUgmXmWRfTLtCiqQNT6XhIAOQTLi8e7tpK4FFA4Ys1ouvjVxIsj6MbD7qwNKovJmFLm0SHy74D8yZ0et4lfcnbo1IjiXVO3rST/q0M9BQVu9nllWm7k5T+qZc42bmsk3YjQw47uWajjEw6D8YkKbBo0OK4/A8ZEybZghehvZ7tzes6Sr+AJyTMjTNBMs16TrWMYhGO5kFAjTMsRDVu81w4fPp82K3H9f9lLArBkqh69wusABTAiNziNxrC6ez6EQlkTJ2dB0gkimq7LLLID4I3nd1VEDJWtmozTkXNTse/K9wTUNBLh/NrT8uPlGen10H65lVNRw8WESCz/+RGAYmpzRjHdwX9l+/K56IYIIFZkTVg6HD4hGPU9aQxWlYCFVfT6Idnwq4AhIiOKD05+xGN87/edtF+TXBGMkBKlCRxIsi3Ghm3uygbgr4/12Mkz6OATQAHDeuan17R2NP/dy
 5TZL3F0K
 cfSy3FF6Kqxv79RVRrBcBHsFuvmpcauQmUuNSfswJ8qIlxp5z40AEgs7/InWoJ0fswLz+MRbcAZmIa016a89GT5eiwh3XPiXF3G+6PXVKDHbWXxbJI3KJXocMgC2WteXI0gciFhG/v01pZq3Mrl20XOenB8/OTFdjd1EMt0JRO1oFkSvGHXpiw7PdKGpkBSzqcMtP+UWj6Y4dRFi3pRKK7sALZGNp7LG87nI1XnDFJDCbo30HgADob6eTTqMDVKczRAXJgPA1PgWRrrqSN2VNxmrqDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 22:14:34 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> "converts it" refers to the access events, so I think it should be
> "them".  Rewrap the paragraph while at it.

Looks good to me.

> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

