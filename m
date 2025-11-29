Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C508D116EA
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 03:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41C3B6B000D; Fri, 28 Nov 2025 22:55:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3606B000E; Fri, 28 Nov 2025 22:55:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330236B0010; Fri, 28 Nov 2025 22:55:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24F4E6B000D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 22:55:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A44DFC0819
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 03:55:08 +0000 (UTC)
X-FDA: 84162279096.12.74582A0
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 09FBB14000C
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 03:55:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=gif53AQX;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764388507;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1dCa0Yi2abB18gZnNstjxBDy+4BryzpI37joEvmB9nM=;
	b=M1YS2Nh1OR9svqrId26G9gW9dt1EIL1XS64koXZw3oXddg44i5kJYfww2itH4/UIAnTqMz
	eFTIuZ8aqkmfmZEXgYyjqMxf2IArZpPH/xuXX37sqmmeePs0uPyP0SpjcDKwMA3fh5NYUT
	R8H+6NrMlNdlMeMZhbnCO7fRjHhY+J4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764388507; a=rsa-sha256;
	cv=none;
	b=ArO48dfOwu8EompHHF2FMtItzi2SuJxpzRW46cOcmQjhZ8ij5HH0NhhG+/RCN2HpHM6aFn
	LEQqY/ORkim+fCYjAX0IHef1D+aOBK9mYMOnANKXBJhCdOgOgVP+wsiI+fvty1IShTsW7d
	CyY3JYK+GlXEgvBIxGWNVfjTL+WGkR8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=gif53AQX;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1dCa0Yi2abB18gZnNstjxBDy+4BryzpI37joEvmB9nM=; b=gif53AQXc1RzHnygPbDtIU0X9L
	pXTFfokzhGNWnuy66xDaEH/e5OK0oyUdCm4pbTUKtbbksPMcXlqSNS0VCZDb2SJIB9J/PGAbtpqbG
	CO8OW3uSLvzVc3N7Das2tMfFe7RiY/yna+fzkylq+2CW5cGxecl6dTfKxhJgvWdBBeoPwcIyDFC2s
	8sQLhqsD1hjniYUK2XVRqXshs+TJ0gYBdaxjzN6imMaYMF+GPISY28ftXIfPzc78DeU0qhSE93uU7
	+1dLgV4XxZb7onQ+ybhE2DK6uXuf5i3CZdI074nrQAY1XXegzlcxto0oJi2wynNGH9zvSxytr5yAR
	kywVSLoA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPC3C-00000000XUf-1HpY;
	Sat, 29 Nov 2025 03:55:10 +0000
Date: Sat, 29 Nov 2025 03:55:10 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: Will Deacon <will@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, jack@suse.com,
	brauner@kernel.org, hch@lst.de, akpm@linux-foundation.org,
	linux@armlinux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, yangerkun@huawei.com,
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com,
	xieyuanbin1@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <20251129035510.GI3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <aShLKpTBr9akSuUG@willie-the-truck>
 <9ff0d134-2c64-4204-bbac-9fdf0867ac46@huaweicloud.com>
 <39d99c56-3c2f-46bd-933f-2aef69d169f3@huaweicloud.com>
 <61757d05-ffce-476d-9b07-88332e5db1b9@huaweicloud.com>
 <aSmUnZZATTn3JD7m@willie-the-truck>
 <b6e23094-f53f-4242-acb5-881bd304d707@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6e23094-f53f-4242-acb5-881bd304d707@huaweicloud.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 09FBB14000C
X-Stat-Signature: ga1y5m9omjwpzd9d4p1aizj89bgofwgj
X-HE-Tag: 1764388506-94197
X-HE-Meta: U2FsdGVkX189ZPd4cHD/JVIiowMm1osjwKL3kK/6QERemdPcNMAS3jGrEuoeQDX9OcBlel1k5xHQ34senWmgViQollbHJSytEmjtqjV8RHBKZEpFk/169TIg0EewvQXl8xNXdQ/kx3kC3epYhgIMK93avdreRHh5ErwLlGxnypWRThfosNOjafW3XVlf4DiyfbzllySMCPX3WxsMFiXwKmhjrmSrLgDM4azhj+LrJVPkH+0nWfTtCezB1VeqT6U1ogYnJjX/PBIdY7mG1vPTBGvq5qcIrfCngENM7GLXrkfnKhMFRu2f77d44GCfcf1xm/1fZcvYMyuK/dSX/gJySjjowXDxWFQk8EUNgWCD+bzZ4Sqk1RuNrwMGEPufVwxVuPOoSfOXC431B8MrDjSo/mfWKOjncngO0E6h2A2XUqHKzgmbW8kRQ+h76ZnYtqnrlJuLL8cPhMV9ntEnaY1AhBfeP3CB7ANJa4r2EmoUqTmDELitrBi4Gn9DKnpWbNQPiC+1vtbTIJEu3GwXHeflRWSHyjZn6oFdi4KmDiVGfW9guTUHTYHyFPYoqklUBqypN9u7bDMuy3sCtKeHY4NCKNq5pIkQ2m12xyZPPsJd95RMokJOZgPktTkDGrAinY+K87doQGMMmqDjjjrHZhBku0B5B0TSQhbOLXEsBh29X/ZR/P0nRcARsjQ0RtO6Vvjclb33zJpqNkupCbsPfCannUjgWT1zkCaCBVtPlheNHM6yKQY5agsc6WyQlPQ03TnrS4AHdfNJtqyucPya8EivkE3rj/KJho+czyU/e7AfD0lVbtdORHfGJe1sPQX6aGJCeWjyEkhRlR2SEGsAB2Whc958UNx6vy4DFN1llXvrvxPVqXX2AsGI+Krbv3lpT443WRSex3mY0LjsnMfrct8JbUOl8s5/Pnpj2JEWiiPWflOZJt4kLFbm+SWmesKuMFOAEEFLiEcbKBXC38XVLEo
 0D26Xbhp
 BmaR4zKjBAtCH4BR4d+cFVBHyhdU/IsBBZNW5IjrsZ0AVGGPgxIMqMuxQP6k2UTvO4JDaXzhsQNrjN+H/DRbdRwO4hu+d6PezhHXXBwxL1sqo/kNKIqT7tkAhIJX3Ul4tIm7v7xX78GWnITaLfMZJUU+AN3xzVkjU4TUipftXEzFXjnOOJxWwMAsc7X6Iidaw+7mDigF3cwjyAq8fMh2Zd0H3YtASa4sqL6GK5nDnO2wG3h6de7eLA4y5zWxU5kiYrlcrWSF6PEGGSMUlabOefl0nGYdTcx0ywJTx4WAHsJfhdqOBeIhknlQ7++f3xLmAXONlxu2Uf30LQMKBmDE0Ne3cUZvjsEcqj+IzGckoc1CmCJpCu+6FRqWrEZDv1TjNRvEQ6D0gga8h1QFg6UPSjc2WJQF9ZldkS1B6fp1cFRYurKLQIM45wVE4EOvS/LE9Fp/bvOey0kqUfBK41YF/6CAHCho1ONzzRPBKUStUzp9I0fc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 09:02:27AM +0800, Zizhi Wo wrote:

> Thank you very much for the answer. For the vmalloc area, I checked the
> call points on the vfs side, such as dentry_string_cmp() or hash_name().
> Their "names addr" are all assigned by kmalloc(), so there should be no
> corresponding issues. But I'm not familiar with the other calling
> points...

Pathname might be a symlink body, sitting in page cache or whatever
->get_link() has returned...

