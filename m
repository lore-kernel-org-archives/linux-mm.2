Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24772F417E3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9131D6B0005; Mon,  9 Mar 2026 10:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0836B0093; Mon,  9 Mar 2026 10:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777BC6B0095; Mon,  9 Mar 2026 10:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68C0C6B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:29:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0956688033
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:29:59 +0000 (UTC)
X-FDA: 84526758918.08.8018058
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 180D2120014
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:29:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=KmBgQxy+;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773066597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bCgFz4UpYVbBeKSYmRS1UHS00xtZH8a/t+DzU0dS+U=;
	b=tZUEZc3ufEWv/LwpuOUX1v9GJEG03e0QIaBGcnp5E9IhNMAIJly7nUAdweL9JSaSlFRcMh
	OLIV5lUbgcgjRAXMfNgLIzNXtr4s5ApZyqMSjJNWPTr35i7um5A6UfJhh5DCrm2B+P9QXs
	EeqTgwxTcIYa69MiqiEQQq+rpCOtztk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=KmBgQxy+;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773066597; a=rsa-sha256;
	cv=none;
	b=ZmKYzA+T5nPK/Br2k64QNcSfbeBQId2XuP5l/XJ5qCik4Q2LVvD35O0HOubnTPHgmUdaU2
	9avlV+JspW9yJm6/DiZst8hWgTKYboIvDwZjqRofshqihJLTYtxxIpDDDH3zx0b/qfhM8/
	JlRD0DWidLUif3VAeYXIPIYK+S5vb94=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cd759f502dso233246785a.3
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 07:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773066596; x=1773671396; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0bCgFz4UpYVbBeKSYmRS1UHS00xtZH8a/t+DzU0dS+U=;
        b=KmBgQxy+Z4kslrtifui52kuDuDeBKv+LRsaTv7gj/fYxTwcp8pgcAjRVunFPONMJ+W
         wuUpbiAhJFr0Et+twzz7ZQ9D07sC0vNQLWJ6VyZwSS9aEaZcjMR+nXSyga5Ltrjo9vcn
         iD01IPr3UXpiqZaau6FVR52dXuARxbb/bobiwcgJS/+GVUoSdLvgMfEILzzQB3JEw5Wu
         8dunQyPQx6RkT8egLdGx2updbjOMXBm40DyDEodvzsDoe5w5M57Dq9CyJ7bZ32IaB3mn
         lcJAvtDihJFKZDef3liNOFdLXo7N9iW/BgNEZz57eTxAAVVdOdEJWv3pQX+QB7cpuEHc
         tSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773066596; x=1773671396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0bCgFz4UpYVbBeKSYmRS1UHS00xtZH8a/t+DzU0dS+U=;
        b=FIpNQ139S43og+F0gG2NVLA4+80LiX79TrEL6nzs3AciGUTFlJ/lgqmKjohgkdnpzI
         5wKUKTBxYKu43aKcssRk5rOR3t+IU8EOxXRjipeSU3ooaE+dBkbJ1jY451pqlF5axU33
         zBOWHAxpO/joi4kpalTRlCfFAtjGWCHfIArwGmm4ZNj2jZaUaEE1lstZZkRELujg0p5a
         6+ItVn2mPQrsyxnhwOcwC7MtkH7JfRwE68rJW0WIbXDU0wJdRFxfFvKcnuxkbgpoBNKa
         J8imf4I5DX+Dia3LPntCpoJ6nMOt+X8g1gG6puB2MT/RYHXORGXLW7mg8oKCsFgntEV9
         nnig==
X-Forwarded-Encrypted: i=1; AJvYcCVEpdNrVf5iN7oWk8knu3N2VWJ/Qc4NJgFMub/QPRO+f4fXl1e3ReIzU0YCKTUl8iRIyycyuIxwRQ==@kvack.org
X-Gm-Message-State: AOJu0Ywu7uzlIHnSmglimeoTCZDINPI+GlLpBKOUzEwXdtsEReyMUcUW
	otkDaxqCil2TCllYWsQVIB4Do/ArXkTNu22ouIkjHlA0LGjhraGrMGbv6AL7nDuDKUw=
X-Gm-Gg: ATEYQzxkXEaTPv6l3tbcEWCLLX42rti0YeKqoTWij9669HC+8PC+9DfekyW+9c63RJb
	jk64KBbv+qbHeAw7QO4wNdsZsaDG0NDV0z6oewKLpLAxn4ggPhzj7wImqmpFc8+ksD1bLJ26po3
	YVqd5PYgMrqtxfTXo3+cXNuzSLdlIZtKhHuJL5ncEs3TP9tHXZ2u0bNko7B2K6kOuK9LuSBs1OK
	v6crbETZTF7lAPhFkD4sN46iQIguGcT8Hang7ZyqqoAHEGrz2vhtvQMdTxx1K+xRthHpCfJvxIp
	TQjDL6FGslnpwK5zpTVJyi4fsUu5NpuAiJED2R5qTZebps2TwSKA5HJsGLVhXj/C4hFrb7ixmqK
	ViOGucnzSrbBoThCykHv/tww2SioTn7CaUxs6w//mduyHhf2G3TuEzWjcH+kQYRydSyK4qcNRB6
	kxlAM/glA0ZZmyAmYXWQzvdvl2BlkW8dUrWFakhP4e/aTu3CFb4I1i7tUiSoMIn3V3u9NhJb79G
	4ZxY9e2
X-Received: by 2002:a05:620a:4809:b0:8ca:305b:749b with SMTP id af79cd13be357-8cd6d4d5456mr1426307785a.60.1773066595964;
        Mon, 09 Mar 2026 07:29:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd8d4cad48sm148711185a.33.2026.03.09.07.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 07:29:55 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vzbcI-0000000GTxY-2R0b;
	Mon, 09 Mar 2026 11:29:54 -0300
Date: Mon, 9 Mar 2026 11:29:54 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	"linux-mm @ kvack . org" <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Leon Romanovsky <leon@kernel.org>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v1 16/16] mm/memory: support VM_MIXEDMAP in
 zap_special_vma_range()
Message-ID: <20260309142954.GM1687929@ziepe.ca>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-17-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-17-david@kernel.org>
X-Stat-Signature: dts6esfp7hxszm115cq5h639uhra1iq8
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 180D2120014
X-HE-Tag: 1773066596-833721
X-HE-Meta: U2FsdGVkX1/Dj6edpDABhjnrnumgYSHWzyuahnbvMC8ILwTJhVP2Nyi8pg842dCWcbW0yojHAlIf3i0j7kP8kZyuwx5r3TPm7iXQ7FKuGI8D0rs3iOwi5PBwLWV40235wnJanh7Pj6I221/Jjt1sE5xwdRMRf1Rl0JUoqMs7nJsE5WfEWF+ITyV3wsAUpox9MEPdHZ+jDetuxHUyuBTbuoX8r6SQnNRL8LqXMu7XN4VRk1yL4gN92g3fc1d9qfW4Ww3GE8OINLTGgOYTGUb/QSJpqc69cesHcG2FmCPy5CUnTmlnRrBbRqA83iWJe9uK0vmrS7+96LxORWMRyz+pvjU9BuI7EKeLNNFsq1griLYlar7Z7X34adW8S3Wv47EKMOtDroSkaa3Y2reJgQyWJ0hU9YnJz6byPF2oNxaZA3Q8j+Zdr5kvBqEeXCdBBV+pgiRD4r3deotNi5IgxR3D7DIJdnn6zI7HAkS9tHGTH5qygD4Gj9IAqAL+3CZwxdudfXNSmPPaytWUevH2QWaZQgN+g986SBKcjTsTZaJcZj4rrQN7WiybMtVOzLnmdaeyVHhYQnqOku9myh3ByqQGLi3dpEKtV8fLluVUARc7fWNmBdIHEMrz6aOxAFpnSPAh28jkZaHYc28TFbGRdc2ljRcrmRGHIMVKmRlLHViUzjw539I81dZOXoMkoC3bMtVvHH7fJfIdU/7GSzTZIBwqPol/S4QR1jc4/mLLwXidRpMgxMOFvhnCRAP8xpiecxVNJontlM4eYnn6PmyLv35Qr9uu2PWwuhcMfOGTj4PMQ/bqTpwB+HHLdtrAuu35jvhmGcTw55MIjD0diGY21ndUWsxgbQwd9T9qb3MIbvBSQuoi2U8BbcmU3oy1tJP9K3WqkOKvFFobV1gqRo3dJ9lfKWAo3f2tKpp9/M6xCVMobvI8ufz9HpAbMwW2qZY2Jfwb7NGU62OFnVTR9CYNmJZ
 30m2PnDF
 hYa6xuSmN4GoPDaYQe/p9MeQwf8i48AYBHWa2YHIu8phnKosw2o1Jh6gk3y8lz17gmyi0Pbwrxkrv5mNmdbAo/KS8OAM/jK17da4d3h2jEY/cM8rox5JJ4NWFtQ8Qy/qjyKqVE2gTKePKArdMcb8QAAEJXQZzUCNfL1Z38dIkgLnVhYlPAnMxQXTnpJNkpPwHj7avAC6lvFJmiERbP6hMxZKumAtgiEKSn3+r64ij8w90ICDXVPkRooocOWzWfS+OOMuMSDOBJcKcwLLOIAQXoAKr8+YVGOUJ31Ze1iEBdU7oaQ9e7tJSl1wESvhurIauQfuUXM2GKhMkX5FKutZOBRWvHatJ0hML7panA4S6aS6VZFnGrRRKPk7jkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:47PM +0100, David Hildenbrand (Arm) wrote:
> There is demand for also zapping page table entries by drivers in
> VM_MIXEDMAP VMAs[1].
> 
> Nothing really speaks against supporting VM_MIXEDMAP for driver use. We
> just don't want arbitrary drivers to zap in ordinary (non-special) VMAs.
> 
> [1] https://lore.kernel.org/r/aYSKyr7StGpGKNqW@google.com

Are we sure about this?

This whole function seems like a hack to support drivers that are not
using an address_space.

I say that as one of the five driver authors who have made this
mistake.

The locking to safely use this function is really hard to do properly,
IDK if binder can shift to use address_space ??

Jason

