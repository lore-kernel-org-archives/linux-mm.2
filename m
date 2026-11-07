Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C852E606A333
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 10:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2hwhDZO
Received: by kanga.kvack.org (Postfix)
	id 629686B05B1; Sat,  7 Nov 2026 05:58:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD086B05B2; Sat,  7 Nov 2026 05:58:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F25E6B05B3; Sat,  7 Nov 2026 05:58:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5026B05B1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 05:58:17 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A3F8540342
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:58:11 +0000 (UTC)
X-FDA: 85408023582.27.6554E7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 08DAA40004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:58:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2hwhDZO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794049090;
	b=hId/J+6f54aiLjDWpI70eIlP/nUv1UEQi5mFnrYPGWxs+C2CI3kzU5Rbf0N4DAAb7B2/as
	lEp5lq11N5QpWlRFcPqKLnzLfHSb3hkW4K0wFnn3hHU0qI+Hseb9eyPaLOtkU+K2EqkEjj
	nH83FXOdNvwH5XM32Sw/R1oY69uTpcQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794049090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88cOKsgzBHwFaeGHE90s/Hp3sATSOyhOlDyqPfKvTro=;
	b=1egpWwPuTCf/DTj7arUnaXO/q2G4u49+C/ORx/XEOjqQ0C7vFJiUFh8SBw0Wbw5WFjGrYY
	/J6BGjSUn2t4yq5eQPHd2RNibsyMyPC65OFxQ8lo5TmtxN2rjf4wsKnQGSOaUA7AnyLaBg
	Lq9XbKx4enZrsoBYFhKJxOa830Ojpio=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2hwhDZO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E6AB60F4D;
	Sat,  7 Nov 2026 10:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBF41F008A2;
	Sat,  7 Nov 2026 10:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794049088;
	bh=88cOKsgzBHwFaeGHE90s/Hp3sATSOyhOlDyqPfKvTro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2hwhDZOeqvqKqrC6smIGGNwBCWOy73kQPVHQ4hDf8zhs731Or+6/0MFanFM8HZ1d
	 3DS2iqtx18ewjMxNwZPsBrxwP3X3cVp5uGjulFw9blzJ8U9x3K99+RMZFClrDn9PL6
	 5tD80HEbB7OCihts7dF/CqgHIW/U2vySiC8+fXU8dq0E1xYe/3g8x8FbfazjokhQD3
	 A5FOpZ70stCEmB3pUSyBvqgf0c6wwrji3dhPqRA2Uy0T8Maj8bs3pJLDzA864gsanM
	 5JdOMRN+WOaITRYKpq1bTqgvLOIOvIM1eM2EOdOg7f+IyaFQ5uJAgWFxvY22NiPWdi
	 OAcEeV4U6zuNg==
From: Mike Rapoport <rppt@kernel.org>
To: Avi Weiss <thnkslprpt@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	akpm@linux-foundation.org,
	rientjes@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mm_init: avoid overflow in percentage-based core sizing
Date: Sat,  7 Nov 2026 12:57:59 +0200
Message-ID: <179404888292.1473634.16271793133324936667.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106072354.2234189-2-thnkslprpt@gmail.com>
References: <20261106072354.2234189-2-thnkslprpt@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 08DAA40004
X-Rspamd-Server: rspam12
X-Stat-Signature: bp7itj3owrag4omn98re5i4nmoowokrz
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794049089-117390
X-HE-Meta: U2FsdGVkX189UnT3KUO+vh5j2ghRzx+id84+APyXWoSbhVz5EnMQTfeg09mViIN4VIFUDGTbtTToYc16oI2zC6Am3P0AnmCj5R8O66+LXUh9G03DFQlYedSAZ+v3Us4oPFeFVhKc195SPbLIaNacFI+htCrPbFhT4bYGZG9uiTwd6HeOLmjMvvwb6hrrqn/J5Qs7kELhdDlWH/s5Uh4D0rIfK9iEF1IXWZWrn48IxRXIG3OvnaLBBiTi1q1NqWWiSar/cHIqYxI+Anpa/8AOYPAks8FepYcyc/4XIVE7IpU4F3qTK9LIHZAAHVFDVWo1d+C6qFIpYriNXQD0ke9qNsrkZXGt6uJJC9FUSY/tTYAu0u5OOgmT3i+9v92Ex8hloR2EV7xSZjRmK5ju25IigfV0i8OGVksnNDseGvn9pQtCMLBo1fNIsCilae5QevqOmmes5qeT4hE7c48wPSmxeBoGUmtI9prFIGs7Y/vvZahfFJB9+q/V1Fs+NzvT0dlIGQ9eNUMTHH8f4X3SSGkgrBhwP9VABU250nlnl9Or7vEK791JU3Oha2sO7hy4lwp26ZPh65C6cGLUCNqOgp2OpEqraZLCKRT7m432kyYZPj7zHKOuGhmlnVyadm0xK2NjDBxn10zUu6KxYUriqF3AUtDDOlhi2GBy8M6Zd0juA1Yje/rMNHxZPjORJB+2/u6+IvxMqPXDt0D8FdXUou+ZlxeMpwUPjcuiTJ3bTErYdtF4hdsg6LsfyRG+etDX/9vaHH3j4J8uFBSkY0Wr5Nnp55A1bqecH/Kz+jHlboS8CxRSU273iBUAHrUncY0ShIfLDYtK/DPI+kOKAFSKb2dN6c/LU5PqhORSjkieoI2Vob24OqaUINF7681QAZ/QuSa2ACKDeIKRGsGNuyTZHiOEwRqzo0C+n+sW9189hQfzD/gG5h3ADS1PFK4irbkqHnLT4YkkCjA554JWjxqmv9c
 KHmq8lU8
 wsY+Tysq2O+ol+3p4R3F36HejLgcbEaNSCv74Bl9RLn5SDNuA8gDVVxI+Hp27QS7AG/owNw0jSTIlmCL/UnzJ9i2a1TRSswnriwbdjzUOKBx5gMwuv6M7si95YaSgJAQv4PvVEe6syL1CzI3s+dY+/KqlAkFmNtzw4jxMtLeBRPaI89vv1pucX5/p2dGNrn78eXrb8Sg6TCK09I5Rag+UlicXxpXdW0J7sYPNvvbg8HdlVzgv7SPUkFjS5uBvetMoS9Awl+uNYQQiNv1PkgupgY/sqsQruzb90J3UKq4ewuumNScSOd7NIDAuA2yPulYuVO0HetVTg+C6rg0XNgERNpQ1KB85iXnuNMmYZReItgBc9fnKoemg865VkJ4I6sRNua472yBkx79kqREwzYpirgpnA6Kt1zZ1S31l0WsweneI6kE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Fri, 06 Nov 2026 09:23:55 +0200, Avi Weiss wrote:
> The kernelcore= and movablecore= percentage calculations multiply the
> total number of pages before dividing. On 32-bit kernels, the
> intermediate unsigned long product can overflow, producing incorrect
> memory zone boundaries. With 2 GiB of RAM and kernelcore=100%, a
> 32-bit HIGHMEM kernel incorrectly creates ZONE_MOVABLE.
> 
> Use mult_frac() to calculate both percentages without overflowing
> the intermediate product.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/1] mm/mm_init: avoid overflow in percentage-based core sizing
      commit: 36557d74a757a4bb71bb1492449680177687f5a1

tree: https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock
branch: for-next

--
Sincerely yours,
Mike.


