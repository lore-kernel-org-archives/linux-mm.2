Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6ABC1099B2D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 17:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7F46B0093; Fri, 20 Mar 2026 13:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80136B009D; Fri, 20 Mar 2026 13:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBCB26B00A0; Fri, 20 Mar 2026 13:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA3B86B0093
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:53:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 544CF8B269
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:53:48 +0000 (UTC)
X-FDA: 84567189336.10.77B739B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9ECC714001B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:53:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uiEYv2bo;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774029226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h//oGyLG5CzZJ3ZAYHDx9XZrR0UhXsRRj9FiPsHwWsY=;
	b=Ot1Jz0rilSVHXYRgxF+05X3TnUvQTuFjuMcw4+SLOfZdBdJLWM7z5nEslV32v9CWTIcS/x
	oS/89cC+rEBLvKk1wOpkq1+/TGS3w+9hET/oDWKeAgbp+gjMgTOfncRpVypiSvcR3908zk
	6p4DBsWlZD4/Ao9Qiiql6SzRwBJ9XEU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uiEYv2bo;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774029226; a=rsa-sha256;
	cv=none;
	b=qJUZx3IHocMYxfm9hFY2+eB2XJvWKatGPwufbqKrryGdlafTl3JF1tAZ1fwoJR0wwBU8Wg
	w2M12YTBHnLcOfp0KhTKNJKbfuhdnzwLTnS65pWb32VP6IR0lHRpI8PJqcWQss843DEGLv
	C32Vl3x6iDCHo6RBSb4Y/1zlJ8tzafQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EE1543251;
	Fri, 20 Mar 2026 17:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEBFC4CEF7;
	Fri, 20 Mar 2026 17:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774029225;
	bh=h//oGyLG5CzZJ3ZAYHDx9XZrR0UhXsRRj9FiPsHwWsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uiEYv2bopFQyYcQTTmao16YHY0s25gTILH0j4Uo/jjcc1jQYIeERrtFpWhHUC8llk
	 1Ivpn0/V4XRXI/ebxqkI+w00aHnOyD6OLBbLiioWe8ikCZxOgwcn6jUDJf9+zEMtY5
	 aerSNmGAA4+YCrYkPDAq+McY+vRNZRaSXuKlRMI1dEfKo14kPd6ELQOZ5s+lSKb6rC
	 twzYcePHq10w7+pUyb6m431OXO6YA+zEDvZ8pS9kgCmfGHwEyheiOGdNqBwvccPZef
	 s3+MOy8YdY+YCgiLvIZ36jeoG/NqOAQEMhcO19dFmHftXh6EO8syhFT2J9kmPnP8HT
	 NHD1pKtb4gA3Q==
Date: Fri, 20 Mar 2026 17:53:43 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>, 
	Eero Kelly <eero.kelly@dfinity.org>, Andrew Battat <andrew.battat@dfinity.org>, 
	Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Message-ID: <6b087c27-a5d5-4f49-81e6-1204209b0c89@lucifer.local>
References: <20260319190409.294523-1-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319190409.294523-1-ziy@nvidia.com>
X-Stat-Signature: 6tp9u6qoiqmwd7rz61k9gth6kc4d33uo
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9ECC714001B
X-HE-Tag: 1774029226-110717
X-HE-Meta: U2FsdGVkX1/NLnMXsbjoobmb3JnvfFYaMObZvP2DEXFrGp8cHbplUX/nEDwsjj1kAcyN5gyWGchvcyXO5rMHVogrTeyhMZbLzGzO4hTTEfiA2nLflpdQJt7vassf4HeghYCO6ozArmSbKPbFgdtXsiQapD+BiIg0t/32DbHUPbjPnv3F4o0s5rkaBTxofKn+k3/Zu8JF14JtY/OvcM7HIxtqi+2Vzz5f7OyoRSpK/ESdMk6cbx2fSrpeUk0j0T+wMnFFquk6KJb5wI1xyhyVS0/W4pgcHZDHN7N+BiSbPqhGcJ7Hsurl2ASOud27dHWHDo+RpSmHhOiBQLOH6p85v1gx8948oPJxTd7afPMsv9R+SNut5JMGzfkgyzYPXmu4/oCPt1/2Bq4MpfWNsIYWkTDxmBwcYKYdASa+K7C3Cm5hW6iVWVUNWlTjSfTC1fqgQuq5WWyR5SaprnwiWIfoL2+hWzzrFdiwDun/Aj87SPVeso5rJQ1Yu9pBpNDzmZ6LxJMq6a+fiVtaSWNaSID3Ihtm7iasUi1R1YpA5d6Lozkog1Jia0A6v9psVgKsO+MbwqwHrq+H6HrxyrQEfwZqVJ7G3z4GfzETsm1Tk625fTrlpan/JbYz28fSwoTplgz8dK+EYtBKBmyIFYP9bDLVpBWNbjaNrZwpDSrnG27vIE3RGibjUuviqVCeQDziAT4baUy89x2b1P2hSUtEpdnkiG24LUvbWKgoBNtGT1VQGD7twrIWe/eWJ8QoJdxo2ts3ntIB2V4GPkaPCePmsdabIM82LxOsaJ4SJxSarKkoHFOz9AbSLcdTn9Aj85otJI/tfva5L4qc7Kyc2QUrJTUTs58I/GcrQWmBsZjzTW/e6omt+5ski74vxstjzqZvaY5sdiXgj57JcpcbUoBDpjeG+ltecpdHa7Wu/2wMlkpQCUe6EJmDQkCB04VqcrpX0vvxlPYDKa9aaJWhbuQu9/Q
 s9MIsgjs
 oXWLYkmxHiaoIki1dxjT+qklbWwLVecLUeIUrbrEnDusoQQ2eEq8uKo0YUXpXd1hXnCPJi2wKOPt43wtUr92sn+pPPS9eLA3Z7+xwfi0WML/yFnRsuPvFzHVyxhaMKASfb6+RqcR2C8oWO/XBhX0LF0o5UU8cpjgway3iOyBmY8737iWlc46Vez4/nJmAoWv6ggnUGc0dyAArS6sQWpj+V5VzR3Wm9lfmKGNaWff0aFFecb08tKWvZ7hJI3Lcj1bqIeAV94OCKIE9xYcNBsdikNUssxp6Dg/s5Agy4cX1GUHxMlau9XvHzlvfzf2G3/rqG3kjcYE9aclaHn7kZ9XAJMBh8WxVSsFYcL3V/B7oeUdvDijaNJc7v9JPdsiLXxMgDx+iXgJangNCGkgYuYc7xqoaU1aY2LG7+Z5d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(-cc old email)

On Thu, Mar 19, 2026 at 03:04:08PM -0400, Zi Yan wrote:
> The added folio_split_race_test is a modified C port of the race condition
> test from [1]. The test creates shmem huge pages, where the main thread
> punches holes in the shmem to cause folio_split() in the kernel and
> a set of 16 threads reads the shmem to cause filemap_get_entry() in the
> kernel. filemap_get_entry() reads the folio and xarray split by
> folio_split() locklessly. The original test[2] is written in rust and uses
> memfd (shmem backed). This C port uses shmem directly and use a single
> process.
>
> Note: the initial rust to C conversion is done by Cursor.
>
> Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/ [1]
> Link: https://github.com/dfinity/thp-madv-remove-test [2]
> Signed-off-by: Bas van Dijk <bas@dfinity.org>
> Signed-off-by: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

No .gitignore entry? :)

(Just saw it flag up locally in git status)

Linus says don't remove, but he doesn't say don't add :P

Cheers, Lorenzo

