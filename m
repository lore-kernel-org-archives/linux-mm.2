Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6372CD4F25
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1391E6B0005; Tue, 12 May 2026 13:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111976B008A; Tue, 12 May 2026 13:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04DC76B008C; Tue, 12 May 2026 13:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC01E6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:37:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94116A0528
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:37:04 +0000 (UTC)
X-FDA: 84759473568.07.1FE8923
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2AC37100004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:37:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJ566vjS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778607423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CXceHQ+5uY6dr0uoy8akEuOKYQTSUeGkVxSiSU1/Msg=;
	b=Xy3OcYzNEJcR3kYU9F6u3mvPzwvuUFSEcDOUaln1P5ZnSgLe6f5UZNZyNxmt/iR1cCF9gG
	hkcY+PQOUB66iBcxg9q0EWe9N3ylWlSLm4YuV5HR8SZyJvMXS1XmkwH+oXQivipq4ExfvZ
	rXWlXCMFednbAxP1w7k2oyNlVmZfhTk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778607423; a=rsa-sha256;
	cv=none;
	b=jFg52uBz0HQroNQJNYs+b9OvrkkK3UJevVLzaLQ3TdX15K0C2qqy3ZWGVhNxhT8wH86nFO
	QiOBUsmH7i1qCbNDQqdPFqTN7kH+KR3gPzSdMNKp4/c8E97OdSVPT416uy+y86f8R0IfWL
	kRywQPMgZOCVgXYDM1oLZmRy+cUxXgY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJ566vjS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8495E60055;
	Tue, 12 May 2026 17:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D284C2BCB0;
	Tue, 12 May 2026 17:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778607422;
	bh=1YWLm6P5dl6Nqn/xSQpMmjICfYZmlh32zBqzh9A+p8A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UJ566vjSXgweHDlHu8LJSIbOY1CkCckjo6GvLQnAACBt5LOXs8Csa98m7zLt//ePU
	 1klnV/b3K5XQLftE0R87bAjMZMWFv6cQ7QZgl97gWK0lts0vfTXRkWdcWbioR3Ksj4
	 E7GPKogEEbPRizsN7xSJLLHKqnUzM8Nmq98fn9Tn2VqhOAJzjyPvBc/3AskWvO4+Qj
	 vGsO1XvRCICUqEdB5j854egpqlzvWd7rC0u+I6ZYlvu5aV8xs9twLdGeRAiRVepNpr
	 oYQBJwgqrn5oBsNeNTZHVb/hR5YnQXGhoztu0lNmVr7wfugkoxgxVq3TSavAMAULe/
	 ezsKx6s7/HMSQ==
Date: Tue, 12 May 2026 07:37:01 -1000
Message-ID: <efa2a7a0fd633cd8fc6a9f5d40eff1c4@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	shuah@kernel.org,
	vishal.moola@gmail.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: check malloc return value in alloc_anon functions
In-Reply-To: <20260512071424.59449-1-lihongfu@kylinos.cn>
References: <20260512071424.59449-1-lihongfu@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AC37100004
X-Rspamd-Server: rspam04
X-Stat-Signature: hijjhidi5ghswahm4n9mxo94355gnyqe
X-HE-Tag: 1778607422-526735
X-HE-Meta: U2FsdGVkX1/Fi73rsTIpj7dcnuOTNBlSmvB02WenQjj1i70Ni+W+XpYM+YRbVn6Ko9hH5YTZHl9SwCpE+oREHOyXRewiutRVQt1M/OiMOcjxBYXW89ldDaFg3OkblG4/rkORFQ7CH/XWovHTKlGESDmKwHgVze6JGrVa+RgGV/EzCmPxiqRBCx4LDoLcDtaAyCYNdCaXbjwV4jrtjD5uKA33gneyNCOgQ0nmZ1XQ3BO4mOy5bcOqa58Qx8BpmsO4P8B24hG0nlta3pohU9HZl/8M5Yqb7dSJbQX0d6BztOKl6Wr8pO1z9MSV4s+xEtsE77Of96hPNnJByprOErLlA3iWZOKYlulktPe6YKsGv6BCA1wmJIWO384BMBS64PMO3mHo84s3hry2zNjL9n7vEygZyJZne9PmVQC9vgKN7YvFK7FhvBsx27M6XV+VskUZZr57LGXAm/JFn02ORjeEu9lJTA5VSX6IzfQ63JULhK82FjXD9MsVObhKH0fNH3wo0eWCQ5V+PtBXK1Q/bqpc14R24glJPbnq9XbpzMUDvE5E4VQLarfi04jKnXqMoOlRi6AF826MDAZ8nuRXePJhMMk/JSGQHtDvOVHPbSSdoSU4ptwd11tIlta8VtATbzJwkWLuAIKpxYRbb5mfmeF6WpGwLukTu6n68UPx4dUp6FOOeY7Ct66ocN3hjy7+8T7EStd5/dc+t2sQTIWJGfbiaJI7yE91Y9nFAXTyzW1nPaNxFoHuLAonYS69if7vkWZ6+Ogu6o2H8Q3STnoRCqz5hy/lfnPzJJawmunUhsyb06TVH5bFcPh3gayo+o5oLpYwDMVigYsOa0HknC0soE86d+P8AikeF7l+H73UMsUlNnswvqjMxwSzQX0n9hxnEsr2VGJQtsNUxO5w6Ug7rRVozUagbHy/0YhJa1FtvCCKEvcUlHhGTa0jxWInLrLkUXGKb6dPTfK7XAglOJsFEBo
 6eXd6P42
 v5RYv+P3llJ2fQzecG1hr1HKQuZebKe0sJGqc5yszpQLKeywYimU9h9B+5pv0SgeHFVBfCa4C+M2b9CJAwNla0HgD5S2qRjSPkQFLkzppphYDGxJMUAi9z3BYjoWcIdX9GRRcQKp/BUJZts3exXmYF9PKD9+cEA4YnwMHHJrnL0mU+wNi4MNJSeuPx7o0Qn47eHPoAVArgzYfMl9E4iyTePXVRjrx16nVixZIuz03ymqyiXPXrIs/n4zNiv2V/gzuUtG8EDSRZ/HXNad+LTHOBdy//+TJ1SLgXNT/s2nWcCFk/KBA48fOPIogYSJgULxWPFp8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

> Hongfu Li (1):
>   selftests/cgroup: check malloc return value in alloc_anon functions

Applied to cgroup/for-7.2.

Thanks.

--
tejun

