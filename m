Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C01EC142B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CAD46B0167; Tue,  3 Mar 2026 05:56:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2046B0168; Tue,  3 Mar 2026 05:56:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C046B0169; Tue,  3 Mar 2026 05:56:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C99296B0167
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:56:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7512BB905D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:56:39 +0000 (UTC)
X-FDA: 84504448518.28.6E92B53
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 53C2DC0006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:56:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=giDJaW0b;
	spf=pass (imf28.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772535397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQfcYf0nTgw81P/IsIDOOQjFjTNPUrLYna+XMlLw958=;
	b=0l3bbLZtk3jLlSRKc+CMM2gTXC6THT9/PKXtazUVQUi6ZgFhAheaW1R9AJZsMUOcNeqgkl
	lOfvPBekOCablqUVziW84j75sH9vq10Bgymx82NDlFTpK4zr34Sd8T4ae0OvJRyWp5C7Y3
	XFqcHGcYApM7Xf5TZ2hcO+izs2Y8OgQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=giDJaW0b;
	spf=pass (imf28.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772535397; a=rsa-sha256;
	cv=none;
	b=RF224zH4VgwwuZ+2X0+XgKH9c1MOaH/AffpfekMQlfhyHf1kfzgHMJX45WjxyHdAvYnYA9
	o6UIDXs9r2pyzZ7y2wY60oTRgkRNODfqf38Gt/YjKlIGjY0ZUGn0ha1Ekz4vnLcxXNA+uK
	+40nwUGEWZI+Azj+nGvd66497kXmtfs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772535396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lQfcYf0nTgw81P/IsIDOOQjFjTNPUrLYna+XMlLw958=;
	b=giDJaW0b0MmY+iUZh77YQqqf96is9U2TAjw8UEtcDfWyiBnGCGItwtRcNNm9EhcCwmkHy9
	wdrBtOl1b50eW+ETbgGKYDzX4T1wGaRsUQfcaaQKMbDquFkDZ7emgWETfvZwNlOU372biK
	1EgTrfyy0ZVs651I/F5onE5SQt8AU6A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74-R91O7FvuP62Aw9I_7hsZqg-1; Tue,
 03 Mar 2026 05:56:31 -0500
X-MC-Unique: R91O7FvuP62Aw9I_7hsZqg-1
X-Mimecast-MFC-AGG-ID: R91O7FvuP62Aw9I_7hsZqg_1772535386
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA3BB1800378;
	Tue,  3 Mar 2026 10:56:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.249])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B3DC31800672;
	Tue,  3 Mar 2026 10:55:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
cc: Alexander Viro <viro@zeniv.linux.org.uk>,
    Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
    Steven Rostedt <rostedt@goodmis.org>,
    Masami Hiramatsu <mhiramat@kernel.org>,
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
    Dan Williams <dan.j.williams@intel.com>,
    Matthew Wilcox <willy@infradead.org>,
    Eric Biggers <ebiggers@kernel.org>,
    "Theodore Y. Ts'o" <tytso@mit.edu>,
    Muchun Song <muchun.song@linux.dev>,
    Oscar Salvador <osalvador@suse.de>,
    David Hildenbrand <david@kernel.org>,
    David Howells <dhowells@redhat.com>,
    Paulo Alcantara <pc@manguebit.org>,
    Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
    Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
    Trond Myklebust <trondmy@kernel.org>,
    Anna Schumaker <anna@kernel.org>,
    Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
    Olga Kornievskaia <okorniev@redhat.com>,
    Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
    Steve French <sfrench@samba.org>,
    Ronnie Sahlberg <ronniesahlberg@gmail.com>,
    Shyam Prasad N <sprasad@microsoft.com>,
    Bharath SM <bharathsm@microsoft.com>,
    Alexander Aring <alex.aring@gmail.com>,
    Ryusuke Konishi <konishi.ryusuke@gmail.com>,
    Viacheslav Dubeyko <slava@dubeyko.com>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Latchesar Ionkov <lucho@ionkov.net>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Christian Schoenebeck <linux_oss@crudebyte.com>,
    David Sterba <dsterba@suse.com>,
    Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
    Luis de Bethencourt <luisbg@kernel.org>,
    Salah Triki <salah.triki@gmail.com>,
    "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
    Ilya Dryomov <idryomov@gmail.com>,
    Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
    coda@cs.cmu.edu, Nicolas Pitre <nico@fluxnic.net>,
    Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>,
    Christoph Hellwig <hch@infradead.org>,
    John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
    Yangtao Li <frank.li@vivo.com>,
    Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
    David Woodhouse <dwmw2@infradead.org>,
    Richard Weinberger <richard@nod.at>,
    Dave Kleikamp <shaggy@kernel.org>,
    Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
    Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
    Joseph Qi <joseph.qi@linux.alibaba.com>,
    Mike Marshall <hubcap@omnibond.com>,
    Martin Brandenburg <martin@omnibond.com>,
    Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
    Zhihao Cheng <chengzhihao1@huawei.com>,
    Damien Le Moal <dlemoal@kernel.org>,
    Naohiro Aota <naohiro.aota@wdc.com>,
    Johannes Thumshirn <jth@kernel.org>,
    John Johansen <john.johansen@canonical.com>,
    Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
    "Serge E. Hallyn" <serge@hallyn.com>,
    Mimi Zohar <zohar@linux.ibm.com>,
    Roberto Sassu <roberto.sassu@huawei.com>,
    Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
    Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
    Stephen Smalley <stephen.smalley.work@gmail.com>,
    Ondrej Mosnacek <omosnace@redhat.com>,
    Casey Schaufler <casey@schaufler-ca.com>,
    Alex Deucher <alexander.deucher@amd.com>,
    Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
    David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
    Sumit Semwal <sumit.semwal@linaro.org>,
    Eric Dumazet <edumazet@google.com>,
    Kuniyuki Iwashima <kuniyu@google.com>,
    Paolo Abeni <pabeni@redhat.com>,
    Willem de Bruijn <willemb@google.com>,
    "David S. Miller" <davem@davemloft.net>,
    Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
    Oleg Nesterov <oleg@redhat.com>,
    Peter Zijlstra <peterz@infradead.org>,
    Ingo Molnar <mingo@redhat.com>,
    Arnaldo Carvalho de Melo <acme@kernel.org>,
    Namhyung Kim <namhyung@kernel.org>,
    Mark Rutland <mark.rutland@arm.com>,
    Alexander Shishkin <alexander.shishkin@linux.intel.com>,
    Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
    Adrian Hunter <adrian.hunter@intel.com>,
    James Clark <james.clark@linaro.org>,
    "Darrick J. Wong" <djwong@kernel.org>,
    Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>,
    Joerg Reuter <jreuter@yaina.de>,
    Marcel Holtmann <marcel@holtmann.org>,
    Johan Hedberg <johan.hedberg@gmail.com>,
    Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
    Oliver Hartkopp <socketcan@hartkopp.net>,
    Marc Kleine-Budde <mkl@pengutronix.de>,
    David Ahern <dsahern@kernel.org>,
    Neal Cardwell <ncardwell@google.com>,
    Steffen Klassert <steffen.klassert@secunet.com>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Remi Denis-Courmont <courmisch@gmail.com>,
    Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
    Xin Long <lucien.xin@gmail.com>,
    Magnus Karlsson <magnus.karlsson@intel.com>,
    Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
    Stanislav Fomichev <sdf@fomichev.me>,
    Alexei Starovoitov <ast@kernel.org>,
    Daniel Borkmann <daniel@iogearbox.net>,
    Jesper Dangaard Brouer <hawk@kernel.org>,
    John Fastabend <john.fastabend@gmail.com>,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
    fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
    linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
    linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
    samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
    v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
    autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
    codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
    linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
    ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
    devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
    apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
    linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
    amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
    linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
    netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
    linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
    linux-hams@vger.kernel.org, linux-x25@vger.kernel.org,
    audit@vger.kernel.org, linux-bluetooth@vger.kernel.org,
    linux-can@vger.kernel.org, linux-sctp@vger.kernel.org,
    bpf@vger.kernel.org
Subject: Re: [PATCH v2 000/110] vfs: change inode->i_ino from unsigned long to u64
MIME-Version: 1.0
Date: Tue, 03 Mar 2026 10:55:32 +0000
Message-ID: <1787281.1772535332@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4Q3Wz3TfFp5uH9hT3zaEbkghzNvYuU8jzLgmk5XjkvY_1772535386
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspamd-Queue-Id: 53C2DC0006
X-Stat-Signature: zbuhu5ky11f9mfsgbzxkb1i83e9sid9a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772535397-232320
X-HE-Meta: U2FsdGVkX19L+zfu0utU+1j1jHQTnfnZPrKDRAPtKmJqU3VHenU0R68uKl1+4G7PSx/4/6MlLKtrixfne6RTeZ6IlDmmB/01/0gLwUMD6UiCe/cxaY2vA46tGj9cFzK/FOiG9p4XZEL8h3Ut3ky0OmaDCsTW6Gz8h5NQXv/m/GrEFbfJon8EMyEmPYx0w3qhgJT7ztTxkYNLssGCbAW+5hwuzeJwkFq/gjzUIbrHKUkrumQf7bjFJDE8fO/jSVObsY3p6pJRisDMOnoCPfajl8MYP2iNek7g3eFesP5fYcdEAWnGta7vvjYd6ZTCrKe8FuHn8f+mShbvxhLNt4y6VbnQr0z65BDrDc/M72FUYJo3aezrRd5g4jhzy0xorWn0fkk7+7ynx7hMjOG2uzD8U8b/O7OiTP9lHkFk6CYcg0wcMkqqIa7vmyay8e4IyTK4FTPlaXkSpSniRf32bCaXrqqwVEERRdVl7waS+vMj8BkxTITsNeKJrppVbAXJ92RwoOxiamPY8K1aU7vCawmGnShTQl/KrGtOIZXQ5osN5pq/R7FpB2DoIFWzVPy9LqbdIEVXTZNAzFAZqM+g8GQw71mfKjOxT8X0c+i4pqQdabv9zdorrk6pGkLb2OYC+O1H9i3O3Sy5PFcdglL4lBWIZi+XAHGFEMjFFbmKi3enayGOj5QcCKu62YvsLsopFJEFC43gsnfSXSzPA7Ng1F95e1CMRZu2RwOyYhixD1W2h/TcMva6Q1J+CCVUcl7Zfd3t3TmMch2jPMnkx+mbISU76ITjQRyJGZaBFmnr88QgSsjIKUty90QaN0C3wqr9DOpnMYZ5kpiy6haEOQbgxSk9bVsqLzZt8cp+jDesXYJ4ZtiQl7fU6pq047Rm0Pztx1cZu1ItqmLW4zzjkL7EbnmWYahwIHrQacotYkGQmr0vF2LOJENTLXwoHRBNeMLeA9sQZyeysukJNY8r+xl0rHG
 yW5qPFY+
 l9MxRvFai76Ex/kSUyLbVwVilTu2ts72WYddm2JgGNa/j9K/Ca1NyXvsdmTLtvbD+ZiEalmeg4WyqrjGueIh0Mf8AZulJXNVNFYXqylj9zIXJBoLCsJ94jUW0Y0Nj2OGA64r1Qxcm5qAn1yswXtrQDSUeDXsXGVmqZPJ3J/vbDkSgT9xXkiN+dTJl41bGLBq4pECuwpMSBk+C39xsp2pWrq26OBrAFwkTJdmBhEJv+0hUtR7SsNa52XaRDrO33kOzQ3yLfVIpnf2RG9m9bMJ5NN7x+x1k56G826bO+/3u2gPDEhEPFvr0UtRu87qpH5rCDewr4l8uVAYKjjB/t591NQ5A1UlwZolv5xw/KIZmcamHS/mHD7qrbrcpYrSyZd8QjnXP9c5Zarb/nWLxOVg0UPr2EY3dwC39eZTWoVWh/i5/Iu/46jMtnd/30J2r51Vfr4ThAUs7rCXfDtn5x98T5RKONtJOjyAkpZfSMZrmWRLXcT6EGlVlvd5wtIZQ7KOyt7Jp88agMvaopojLykh/mudmhAXQ7YJxER3iURywt7p3iDotDxwR16PflmPLGZF9DkKA+U+yLGu1x2YgJlplz7fgwnYwG9srqNH99ywyDZoANBKO99DLb+XplPGg9H29LZOj3WYSntmm7yEDrEWGJS7Ie/MhccdfAxlHa9qmbz9z2apmg84nO5tnifxNF3JdmXcjkqW4BYneSlBr+Ni9JRylw+YjpKtqNOXJP43l46puTC9hSOSE2bb34w7k/XqAvwdasCGfDY8CFKbd8XlMfRdd0jCpiCiCyIXq5peeVMu37B8TBLMjGqAEME/exYIubVA3YNU9/0ZyT9uAt9eaoul2E3cqnY5vQRjRHlaX16YRSLrTCjj9RTMR5lUMePe/OtCBJaEkEtJWjEORTsvNSRXJ3ci5Xl0AX5apJdOLGzsdJTHsf2EJg++mPuOeUtVw/4GLz+0l6WvY7GjCjKBwOmshsagd
 gJPctugS
 nfB9l+G5oGyw2C3D2tHoMeRLhirnLcyLg1rD2O3vj31DlLPdWYSjfO9CQrRJ//sBJZGJIOWTKdXI9+124plWuX3nbdGZtq2XCegtoPWhJEiDLs/i4WNvcKgZ/cwvwn/JLPCHqaK8sDCCitn4lfLwobNM1Nkf40CyXKZbJkWyjCW7nb9SddIPE9EgfiJeDYzV3pXfOHAtSaMrIIKZmxOgz13tAEWYPYyfpB576rKXQfcUpADYUr51onp5hLiGAnyJBS20v01QgeLrco23wRvsa2sRiAz31z6lrHUp5O5o2o0FLB/+iMAj3hcOqDmmSQtjgEHHzxHRBPusvOtkggpi3k2szCRozullxgHRxKproOZVL94ATBXy27wl7pgkmmXUQd8pHu/ccGH34xxne++JnXD+jEmUEMNCMLbN2N82FMvTFhGY0GUrcJX0HG7KeI1y7X0EYdZmDA3ofIQvIipfEC2/0CbtwOD9aDm7MjUzIYy7BtMM8wGeamp7Bsr/JSOnHyNGDqb/nXDTp9oXBbO2Ruz1uqQHA2S7X/4XtqsAquBuZHu+6OVlPMD6FT/X3Oh4sB2J3M2h41NO2GPN0qAaoYvfd/6a1iFj5uaNoe2Ahm65KgAAGkF0am5655g3RcWTFN9kASZuKXSn1JlIUvk64WB+3ELhyS6Vm5yLbZfdd5LFVdzfeUCg9FCN4s0wHHgV/+PIk9XTI62yRhvq8xeYpt6+SixpH/moXhzutFDk91WEZ13PzEHUVdSzYgluMnLOutmXhVbQ3b0Xfc96D2QvabGq2kKg1bEwNKf7cTNUY4yL+6sFp6uN5Su6GpGBt/tTn7EVJrJMD6AxrxJ0rfa9XMirlb2n3URkPqslgJ/gx2vGXuB/+25ZSuW4OQRpnjYnaQqyhQiykeDI886oNu+KvTKgx5h61f156envGiBH8WoMpK+EwhYaU6ZX6HsdGW7nk0o4L75nMBwyeAAw2JgX5ZG2xO3m1
 2kNHP5w0
 bbxjt1AydT7soQ23nPsmUcHw9YPjYu3eJxGsJY0bRKCpnvMsSnxiGRjt1BoTcP7ezdeDpG8yzdU2DwcvtVH5KbIvtYNcFXibvrWf6aiPABJnwS4rquDPQpxXrbStNNIpja+5TUXvy3VPkcZXkfKhZhnW56PRscG4Qx+XIXHVeTHJxepMdva9M7rudx2iAvifxL85PQywTrX1C37+Nbz+kYg4XOlKGLx5OhZDDwwY3cb62DIGt0sYB/kGmR47Wvc4ZfQuYh2JF8zPxZyBYEI789EudHORhYzmLVd5ZeeOSf0qi7Dky/cnqQE5dADttGiAZAUhexeQ+khUlwEzzh59Ttr2cEZx5TVWx3be6asaCaOx0LsZk1gf546pirE7Qj5sv4+JORqP9DIEC2/dha1+Ihi7Y0wsYWcgCqTTAqBPJJ6tLd2YepYXKCjLeYzY4akXOpf0GFga4Gq0dPQRGr7xd2hUo6FCd7VTdjI6UdutaawFLLjfbNW04uVXaav1XmMVQ1U2X3ENexqMExmQOd3JhQzVQfuo0vgI/KvGCnspfrbtX8JCCt0+slfW2GUgwle8x4pXpZ3qBZ6eUdoKrUpIsFO6mDAR8LtzkiIGR9yNvyXuGG4rCkYdzUZ/WTr/zJB9EVGGHOQf3OoLqaQFx0QC7ZVNiMc+Yvul+HkPLRrfZbFjlW0z71ge7Ma04yHL9v+jleo1HIOdKCXih2/bNrmkBhS7PRjvLYEuT+BtPtDo4OtUorFtB/awngbFkLyBE8HOoyg4GhdkUBQJdoxukUpCZ8YXoSK14+4xQao5Gr5EC0ZWM6+xI0zHyEuoSshXRPQF4OOzlzx4571dh8G192JBUW5jcIlBXouCd8w/KUu6Cjhtb1xEVClpJfmqLXPSVFP5vl6sddmd3vIE37UZx4mBFp4kE462oqG/aiggwiMPCgYlH1+lnh9Qb3muhSfJoAC8/nvTzkpwqHf1tRFfmXxpLH6ui5x/S
 5SZp4pcL
 yE3JPSp7530xtk3f2efqAFVApb3myudObcbDHZ3HQ9Fx7+X4IKmYFWgE3EbTEpOOZvA/fMzlq52/Dg9WRZFC70qiH+X3qhXZCjW9ZkCxkk7xRmhX5wuS0UWgBZWTNcf7AxqxTpiFmA8rONfG7QGaafe+PnuM09O1tavzmGmheaX51rUbV6aTs8678BrjsPilyFMlOhKumXlibboDiTcXnPZGOFXzyNAd0XAhG3Z3fmuicaU/fiNKJ/H27t7syAUAa8/MstxKvKV3Ugi6/xxz3rJKrXjwn4Yfsqq6HMIxKjJk2RN0zpLhwBvwxYtjN42hm2bK6j0aMSM36V8oXXP5eQk/F+QuSz9RqQ2SQ/DJVFTIIi/0JhqfqGKw2Q9d4Vuvsd9wSqhgPggRHYYYNJ0fupMrhkFWTMt7AYjzISi8FrRo7Cm5Emy6sY2Zw+4EjuIh8V+eDTG6aFcG6ed6Ueln8QqGkH5T0WfkWUt5n9pLIbdbJ+rFh8ybD4xdqyLt6CIBwgCacNk7j9fDFn8DA/ik/jSnEhcL79v0Ckn511SLc7H/vjIMgmo/txqW85PJQZiEEOKUKYpnBxLFCQmc6ia9QV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> wrote:

> This version splits the change up to be more bisectable. It first adds a
> new kino_t typedef and a new "PRIino" macro to hold the width specifier
> for format strings. The conversion is done, and then everything is
> changed to remove the new macro and typedef.

Why remove the typedef?  It might be better to keep it.

David


