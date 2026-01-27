Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D65E3D2F02F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 13:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2480A6B0089; Tue, 27 Jan 2026 08:41:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229456B008A; Tue, 27 Jan 2026 08:41:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155806B0092; Tue, 27 Jan 2026 08:41:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0556C6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:41:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A04601AF452
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:41:43 +0000 (UTC)
X-FDA: 84377856486.11.9FC37F5
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id B342DC0013
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:41:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XPV+iVx+
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769521301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOKXG9Ip0SkC/9AL3ADC9BHQKfkdAPIL06Iyiewce+M=;
	b=SP2N/98C2ZZjolikM2vL16Kn0FWDnkOS0JbP4pOZs8NPapUf5shwfsq9Iju6DPqs6ZDgvf
	89S5/+tUC9uRq77Rht4XzP5xnJ3IgrcG9uCn7TVyRXnCINr05NQ1Tt0ZFcnn2UNOWuYc25
	gYZYz5XNkPxLCsEXQc1WHY+yozR22m0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XPV+iVx+;
	spf=none (imf22.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769521302; a=rsa-sha256;
	cv=none;
	b=7yc8hr1zmi3WCuVdSttgv3lGvAfDQH6veJMU1rYIoDtLBbyT1hJV3IqM1O9a3GzIBnkm3V
	E2ihAGlkPX/sgB6bekecJjauwMJrvD/rT06FljUb0mVYdToi1f75uxK0uBttEiNgJuPkvE
	Bhqt9TUzldkEwydJEy4AcS7zCYlcvz8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iOKXG9Ip0SkC/9AL3ADC9BHQKfkdAPIL06Iyiewce+M=; b=XPV+iVx+ZIFtWaKrh6b6E4xDHB
	ZJyuVmOr0YljMY9/gmubl4zzEWzrCOkf8F+BEdjmncQKD24E6FWFbwJ3MSBEKe+gGAKKTjDHlGJ9u
	xWOSGU9lvjzX70n6bdidltR2U8VfJ6yfRNn0L0Wz4Ou82e5GmRhAnYnfpfBgXv4P5PrZBWWKKfp7p
	dvwtZtq1Hzwh8JSPjQWhAyC71zm7NIzojalrDW2hRDKRGMoBaBTeNOKYGYwKwoE8wky/Y8Z9ZAg1Q
	wPoV4ywJIEECerFpq3c4F17aazK0/1KL+zJJ6lxtd9sO44MWfnRdWDhO0lHVvJXHB5hyFmimjLn5g
	p6ozUb9Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkjJv-00H1lR-9u; Tue, 27 Jan 2026 13:41:27 +0000
Date: Tue, 27 Jan 2026 05:41:22 -0800
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, riel@surriel.com, 
	SeongJae Park <sj@kernel.org>, kernel-team@meta.com
Subject: Re: [PATCH v5 2/4] kho: rename fdt parameter to blob in
 kho_add/remove_subtree()
Message-ID: <aXi_ppb4P1QFSqR7@gmail.com>
References: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
 <20260126-kho-v5-2-7cd0f69ab204@debian.org>
 <aXhovDdoLqcmSWVW@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXhovDdoLqcmSWVW@kernel.org>
X-Debian-User: leitao
X-Stat-Signature: gpnk4hxxujzw8qdhissh9se48gw7gdkw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B342DC0013
X-HE-Tag: 1769521301-330950
X-HE-Meta: U2FsdGVkX1/fm8ViS+NN9OE9NoGHO6wAYFw9YowENer9m7fRUwh2PG4U+xAbhoJmQ/ACUFANwUkhXOAV8GlKYsZhDeltyt8qDuvDdn0PazKQW/YssiM1fAegpsczrDIGetnuuPnnzWiknXormYOYk2KN5Ayh5ChWObJX5ntcGQZhnGHC77hrLTE6mcyZdo7FSPlHK8KMhnI3JrjNnO558/0VAkVUizO6Xz2QgSC1IlFM3fDzGw3uI8IZ1zdke6RoywDHDqqF9LkqV1+okQgHMBOEvuOOkfSzleT8q6qU1c7IhNWcVpihE0T7ve/sSgnc53PfJVIPbFNg5C6IxCL+PZyyui/kwortz5/9H81iHL7ZdGhjKqEnsZ78FSTo1rzwT+YGW4iItqgdEtII4IU/HLXukpzzErJlqKL91DR0Xx7cwU+jMwfre23eFlpxlK7mljdEL5ibNlg9ksqaUXEEEiCtshZYCEAOmQkHjaiOe2lLysnk+ph6v6Z9cgBhsexkWEEscHDJjy/gUqbfgVKjyXDVHuhequBjdl1q6+ino06DncCZL/X0oaPXFmsmhWW7X8MPu2JpWdaz9ffKCuqbnCva0DWGuC7pGNIILArTQvdGdIq31K29polQthdO9P2IM/cklrfgvcEQ9uccnha/HsFvElZrzw3LJO2v8guUDqL3RXCRWMbKCSsIDzGZp4HYwjgJH0E0BqepCPqMy5mOzkRoC44EzOobcxsorISLkIQmmcX7kWpbuTXUG28+MNkAy9CC032whn9jq3/ZtFf56SJSrTAbwg2wjzfUNNGhaKRJoTNYwYozl4BJ/z1cNB1iQm6vvIgSEeDrx+RDJbbXrrN3GQ6ME4r0/J1mo3o94Gl/Ct4G3KpdotWgawt4BxXUnTojuHTmpfmH/lWv6K3OAp+njmsvsmoGRZMcs93lT/VuZYDN1wqKNgo+U5iFeiRs+uO0XKz7B4sl2dItmol
 S4+Z7Y50
 GYzhKgls+EOwyqSwp/lIZ5j6/5LFVA1B3nVYkOP8sVBcQlVMrznScbKUVpIK8CpeHtiCrR4tsc7ep76qsRk4SuotaCmVTuouywoVGP/to6rbTxl6uw71SYOkBJ8YzQQK8Zy89CmfE6n4yQsfS+acuSstsJOk4QPsQBZ9re9KcLXhg53GOkVLOoW0Lfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Helo Mike,

On Tue, Jan 27, 2026 at 09:26:52AM +0200, Mike Rapoport wrote:
> On Mon, Jan 26, 2026 at 08:07:24AM -0800, Breno Leitao wrote:
> > Since kho_add_subtree() now accepts arbitrary data blobs (not just
> > FDTs), rename the parameter from 'fdt' to 'blob' to better reflect
> > its purpose. Apply the same rename to kho_remove_subtree() for
> > consistency.
>  
> So if we are doing renames, let's take care of kho_debugfs_fdt_*() as well.

Sure. I am happy to do it. I will update the functions name as well,
basically s/fdt/blob in the function defition. 

Something like:

	kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
			const void *blob, size_t size, bool root)

	void kho_debugfs_blob_remove(struct kho_debugfs *dbg, void *blob);

Thanks for the review,
--breno

