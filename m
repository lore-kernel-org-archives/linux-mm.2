Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62DD6606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 14:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OCaH7VEe
Received: by kanga.kvack.org (Postfix)
	id 6D9D36B00EF; Tue, 17 Nov 2026 09:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68AC06B05B0; Tue, 17 Nov 2026 09:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A08D6B05B1; Tue, 17 Nov 2026 09:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED386B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:16:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD470C0441
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:16:24 +0000 (UTC)
X-FDA: 85444811088.25.C2A3FD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DBDB916000D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:16:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCaH7VEe;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794924983;
	b=ovf/OOoFw4AluNNs96w/dyBuTsRkj9ePia+gR7MfAdO92TQjC1c4VkEsgxdOMUB49J/ZCg
	fSjwoPT57vvw1VX281nm0VvurqmaomaFnvRNpW7VhYvB7Fag2wLNkDTRQqXl/Us3G05WSG
	6T3L+qBLlqDX/PnqjKD7gJT8nqG/wHE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCaH7VEe;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794924983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cM69XD6jCQAyvU5JbNH+E2DCO/IIg1MBUqnf3B97zP4=;
	b=6pUsJeWgl8JI6O2wkeCac0bkIM1ufhNGLdnhxhiYVNdyrlvmIkbfte8fY/kEfhMMGBbmuZ
	UtmVCbhTX+fKKdC8vajCAsdfbkOMK0Ufiy7yUGfNt8RD5LYFi7dq91mLLCQnv1l822eV/5
	cvwf0cu5CLox9iC21sI0UfMD1TzyRCg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65E9C63542;
	Tue, 17 Nov 2026 14:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F4F1F000C8;
	Tue, 17 Nov 2026 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794924981;
	bh=cM69XD6jCQAyvU5JbNH+E2DCO/IIg1MBUqnf3B97zP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCaH7VEeTQRdiRW56c7+s5byHdlpeJIDJ73r90cB5ISn2fCL0UXy/EZR2jw79lmay
	 PwYZLyV8DM6vGH7lgoJn3lGb4cLqAOhoYf0cNZ1GuD3e9i9fcWZa8fIYrR6y6eOi6n
	 vqh2QRDfhgTCRWYsUUJAgSWRtzmjiS6+mXo6uKNGJr2RNf6Gpt4HXnTPU9OBU37OzV
	 uBIdjNdZqhZzF2je1wv3lJoZhlfyOJH9OYvPblEyY3ZGLEHgzT6kea2sMukYqlhgHY
	 EQoYn4Kcl8zGr0I1DjSVXHQ+2IudrewbpuxH6ivzH0ylH7DLGncqoYbtAxkE6KoKdp
	 8HV9RkmjiW7mg==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	mattathias.pinchover@uber.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	damon@lists.linux.dev,
	Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 3/6] mm/damon/tests/core-kunit: test sz_ops_filter_passed_last
Date: Tue, 17 Nov 2026 06:16:12 -0800
Message-ID: <20261117141613.121192-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179488734513.2.6285120857568566018.b4-reply@b4>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DBDB916000D
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3ix55ewhkpchqf9gtgg4maphq84qcnzj
X-Rspam-User: 
X-HE-Tag: 1794924982-16911
X-HE-Meta: U2FsdGVkX19MZZyGA+Tv39E2kAgsM/vpApYgfTNnd2Jz6FurjRgL1z1kt891DxqDLyqK9FKjcYwaQxJ2+GVPdj2ByJF9xaZtjS7raViKwGkchXYFAwd5uLWKLjxLY41z3CFq1EjHAhwjQCzzvcRjNaM/lNFKByh+D9UBEj9re+eHI+3aJ5Ksq/IxHzPqgiYtZjNuU7IlHp16XEE0HL7WKMyWLTKXBSlEiJztZt3giEM/EpY8WREI9N7uFQdzgXeaUjOQlPA7mmXZ4SjHPjsOGMmYQvEJEYNcX43/+QWyHvpG5VQsSUT0k3hGczNaLUJ87A5r8fmaqitHCnvMaOF3KcUPL9M/mQ14zPG03c1ubSEkcyI1ELHQFsXm5MHyzKWFH5YpT3hhMNrEoWZHDNekfVeV5HI/TQgOaKNyhyibvPV0Q6AJHZcQL86N/8eWTXouz3OYMCDI9J32mRr4jtqyVG+PqAuYIJMz//nDuW8Uqk+i7BKXjb0F21KLiy1i5o+3Um+iaWsXrHO+1Zd/sBzd14Bz5+lRqWy60bOm07zgTFqLrBc1TlxBHvbbtlJ4b1FXxyWZg1OvKMyFNIKqoZ/jZwAlw8hHmdb1kIbFAFHdZgChTcmjzkMEbqyJCK2GTsy49OkGCUWrPZ5/mfyxvcPL49aggHRJzmMEpoS+Z+DVjGZ0u9Xd1+C0dn3n7I+DPZie/upap8Jm8kBLXvppgOPvmcnNbWzSjQgNL8qmZBBQ0lmn6OjNIp8ww7j3xQ1vSkn1PsoMNno/h34t6/u99IKmaPJOO2h3RxjlnG/tYvLWGobHOSiwh37osse8Hvm4pCruIA29NdDAQnebjTwx1zpsmrG+ktk4215o6U8F4O5ZlZFdgrdaIeK1bj7YSxK2GXZ5hgbVwp7Ei61VepneqFkoWbz+kE7dKfHxJoOo04lu8O9LFdJ4A75Pef7jJdKJeDVxRavst6COyxwBI+T5idX
 1+gb1JEO
 CGzIB1ATfjnsnYXInNfbbDM9LZyjdLUVaDbdwdMMubuvy92g7oNdWDClsRUnaqEU9DlN99+/ljXPabBdEaeH5DJ/29Onkd+FB6Q6sNYsup7N+OJOa8nXACieTe6FiBKJUCxNAYxM8okzOS8Mkx7SY+hDrs1BvM9Yjk2OGsnn6bqYfA0Tjhpxkxk6Sj3A/cuChTp2Bd2q2/zWwjFaDKg0IbJZZL5k1YD0p/1EhMsZ/xHLZ9CVlqXCcGRpU4kQAkmkuYbEYXmzWXPbHSweWUXB6+pvDOJOIdYgp3VQB+P3ZGiqvLkg5HyWNmEA5jXvVx4epHGqFeZgPDg48xHqTydU+pdLxOfOhv6CntxS3BK4Km21i2a2vrPHkaFLpCuMZ5oQe3AyjBj+7XHR16j5GcJz2l7JcuKoxylGg/YwUDdoeba8RvolAC2RO1LshWLv/4nSd/DBs19C/4xlNImZGhYbdtOuUv1FtXtKpQwza
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 14:49:05 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi Mattathias,
> 
> On Mon, 16 Nov 2026 19:10:06 +0000 Mattathias Pinchover via B4 Relay wrote:
> 
> > Add a kunit test for the sz_ops_filter_passed_last DAMOS stat.
> 
> Since the motivation mentions contexts with multiple targets, maybe we
> could also cover two targets in the same context, with the stub returning
> different sizes for each? Checking their sum, then changing the sizes for
> the next interval, would verify both aggregation across targets and that
> the value only includes the latest interval.

I concern if that will make this test too complicated.  Testing those would be
good, but not necessarily for sz_ops_filter_passed_last, in my opinion.  Those
may deserve a separate test, if there is no test covering that.


Thanks,
SJ

[...]

