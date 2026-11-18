Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65AB0606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gBGjUbGI
Received: by kanga.kvack.org (Postfix)
	id 876576B05B1; Wed, 18 Nov 2026 09:41:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84DAB6B05B3; Wed, 18 Nov 2026 09:41:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AB36B05B6; Wed, 18 Nov 2026 09:41:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBA36B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:41:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED3E51607A6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:41:39 +0000 (UTC)
X-FDA: 85448503518.18.41C9A91
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id E76361C0007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:41:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gBGjUbGI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of jocolema@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=jocolema@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795012898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wxU3d2BtYa9n3sGwgS81YBp+BaQBDVvXZNu9QMElTjM=;
	b=dzTF1cOVpi76A1HSevYX1BaQl2RfXLrXd5WtNWEAz54Sn6oScUsBrYOU5swWhY7vSqxit4
	bCx2QZqspkLgokKjuwMjayLfOYx2S0A51bg4eciNPINlwVTKO3vutdZdvUprqGddP2TQLV
	OSq17TqOC+tdiEqk1MpsbxHEsclGuc4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gBGjUbGI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of jocolema@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=jocolema@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795012898;
	b=sjRp6byk/7gxpAZ9YLImPMIsJZZW8WSLUDcprTzGCZaF7ZqGFg0QC7hzognwEvLH1MOdPU
	et5iW5UEsrPaV3KFPNt5Z9/83n0Z6qo48XfTfQO7SouVzy8uQSF6ysnsV94nwTkbyUkEs5
	c/mURArY//JQXF8G1i8V9MjfFMHITNQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795012897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wxU3d2BtYa9n3sGwgS81YBp+BaQBDVvXZNu9QMElTjM=;
	b=gBGjUbGIo8UaQG1wpauhtekf9NJvkr3+aq6T9DNuoWUzRzFMwTcPztztSY5lDJX7WRC24u
	nfWBZnzie+eO+RMDvg4JxZ/ar1ZjRg3P3qj+xmiL2M4e2dR2HrutFD0HQ4rfa+MAaM921E
	wk15h0m5sn8ZUN0OWMVDdc0uJvpTQfQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-2uacoIF3MgCeoqTcc7XjLA-1; Wed,
 18 Nov 2026 09:41:34 -0500
X-MC-Unique: 2uacoIF3MgCeoqTcc7XjLA-1
X-Mimecast-MFC-AGG-ID: 2uacoIF3MgCeoqTcc7XjLA_1795012892
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D6E4819560B4;
	Wed, 18 Nov 2026 14:41:31 +0000 (UTC)
Received: from jocolema-thinkpadp1gen4i.rmtusco.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 728361801977;
	Wed, 18 Nov 2026 14:41:28 +0000 (UTC)
From: "John J. Coleman" <jocolema@redhat.com>
To: zenghui.yu@linux.dev
Cc: akpm@linux-foundation.org,
	audra@redhat.com,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH] selftests/mm: allocate nr_pages based on pmd size for uffd pmd_move tests
Date: Wed, 18 Nov 2026 07:41:15 -0700
Message-ID: <20261118144115.2112331-1-jocolema@redhat.com>
In-Reply-To: <38118330-5cd6-4f32-9098-a3d07cc7b3cf@linux.dev>
References: <38118330-5cd6-4f32-9098-a3d07cc7b3cf@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: ug1a6eaySApozEoktk_-aAwGLsDwxmbNttGTfFX2t00_1795012892
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: E76361C0007
X-Stat-Signature: ca8ky491t39cx8o4w7ba5ru78fcbqezf
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795012897-128068
X-HE-Meta: U2FsdGVkX1/ZNuxfSKqCP/nsDYYdDOHKdHAztfzPNwm3mKYQsycE9RUVaM4Eb6tQ8vINFlGUlI/9opBE5x2Xd7q9J/hMMBEnpVa9hNFsQsBy9fdmjZVVWnVQMR+ZonucH1HCDUwLyS9niaPyLfqGT8ZmZmwKXAxgyC8wvFMCQ0s+kdXySHTxM5xEFAVm0B6L1TmPefyG5CK4/sY+sV/zphjST7Fg/yCIKqS8ydsmkpFe1QWJ0s9gtc3NHl+cg5tD/xRm+cZrmJgcF8KMTL62jOPLyWqHoEU3gV/YguBg4dAEgW6KAYK0becaG0GUxpvqgbnELdrI4cOr3X/lkXcZb0V17a/luiNClZtpjD1Qt80BwbFoqXQ6jaSBM6+GXHGT+MY5Nlw2D6NxJkH71o/05TZRGWpro255TQ37SqEvJmUyukCkoTetPDfxeHLljCH1y29IEafWzKSi6bNguwem261GZhGTfX2AaZRviJtrGqUdFi/hVT766L+9Mbn3Hzzg9+aBNwTKVXj/8g0lxReMS6O3ybF/nggg22BhYBssOeXzFzTANbgema4Y1+0M0e4f6cYnbp4z7eM1UjTOKcqwHB1LzLNdS5+Zu/JDPl2DBFV6hRw86PT2OdNKQnhJ6JmmPcRx6GtFM2pJC3G3EQhK9pY5CNCIHm7pSulkpKLrCFRBU0XWWivq4K4hPnU5OuT0T8ZTyfUeLlt/E0pllcL4/9Y5JGt2D1LRphc1othxfggpk+wRTRaNbV+qFrqenlrBwqrX4optUNVnzFTvyLTsOKpjFw+8L67eHib/vgcPXRyiRXKh/L6L3VejkjfqUHt9zAfDOPs3B7QAABUiXY+uvpS4/xzMbbYzpWI+hYEIRVcsw+L6Sfl0lAa+aWXNu3WG0WLrWV2/Qro7iQ8ScoBfeaNbDgogLRjpRIwVY+8QiUsZatbWOPjzwY0GiPE4jMbqdCbo2GNxEAglhB3A0An
 wuKXt23n
 2epJ+UalJDGPlW3W7TwlVu8O2JJAPHxqUDNcK6KXB+uquDC9bA63XbD5CWnG8sASzxQL0QsN+MEU8ZvpWbVPkXxagIKrs+hHkNwCP0E3goqmLaOhtNqv1fk1Ohj9SJDgCXeOc/6MxZO5AMs3s6oSN9WYI04MlbTEz/uzNrX/BEyh0aZ84LiYeDdoW2RBU1uy7l04VGykbChy/Hbq8gdlO6/eVfzVzUnSoID8pzOT2thsk6nrMNRF8Dw2rmUn9mt3beetQDPz/bJeRJn3WERa2EOKgEbXNFhoSMTjp8GGOqbMoc2rMZep2K29BH1UcnMQqyWeEO/Cb5kKpNHpXvzCTnUybaGIh+v+iZ3r/7SR/wLfPot17w3VgGB+0/IWMQ7bfRiHyMuhAkZF4FAZGiRiloPlGLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thank you Zenghui, I appreciate it!


